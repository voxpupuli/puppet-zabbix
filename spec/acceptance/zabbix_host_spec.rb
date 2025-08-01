# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

# rubocop:disable RSpec/LetBeforeExamples
describe 'zabbix_host type' do
  supported_server_versions(default[:platform]).each do |zabbix_version|
    # Zabbix 7.0 removed the deprecated params 'user' in favor to 'username'
    next if zabbix_version >= '7.0'

    context "create zabbix_host resources with zabbix version #{zabbix_version}" do
      # This will deploy a running Zabbix setup (server, web, db) which we can
      # use for custom type tests

      template = case zabbix_version
                 when '5.0'
                   ['Template OS Linux by Zabbix agent', 'Template Module ICMP Ping']
                 else
                   ['Linux by Zabbix agent', 'ICMP Ping']
                 end

      template_snmp = case zabbix_version
                      when '5.0'
                        ['Template OS Linux SNMP']
                      else
                        ['Linux by SNMP']
                      end

      pp1 = <<-EOS
        class { 'zabbix':
          zabbix_version   => "#{zabbix_version}",
          zabbix_url       => 'localhost',
          zabbix_api_user  => 'Admin',
          zabbix_api_pass  => 'zabbix',
          apache_use_ssl   => false,
          manage_resources => true,
        }
      EOS

      # setup zabbix. Apache module isn't idempotent and requires a second run
      it 'works with no error on the first apply' do
        # Cleanup old database
        prepare_host

        apply_manifest(pp1, catch_failures: true)
      end

      it 'works with no error on the second apply' do
        apply_manifest(pp1, catch_failures: true)
      end

      # Zabbix 6.0 on EL9 tests seem to fail as Zabbix is still starting when trying to add the hosts
      # This adds a wait in case of Zabbix 6.0 on all EL (to be sure)
      if zabbix_version == '6.0'
        pp_wait = <<-EOS
          if $facts['os']['family'] == 'RedHat' {
            exec { 'Sleep 15 seconds' :
              command => 'sleep 15',
              path    => '/usr/bin:/bin',
            }
          }
        EOS
        it 'waits 15 seconds before proceeding' do
          apply_manifest(pp_wait, catch_failures: true)
        end
      end
      # setup hosts within zabbix
      pp2 = <<-EOS
        zabbix_host { 'test1.example.com':
          ipaddress    => '127.0.0.1',
          use_ip       => true,
          port         => 10050,
          groups       => ['TestgroupOne'],
          group_create => true,
          templates    => #{template},
          macros       => [],
        }

        zabbix_host { 'test2.example.com':
          ipaddress => '127.0.0.2',
          use_ip    => false,
          port      => 1050,
          groups    => ['Virtual machines'],
          templates => #{template},
          macros    => [],
        }
      EOS

      it 'works with no error on the third apply' do
        apply_manifest(pp2, catch_failures: true)
      end

      it 'works without changes on the fourth apply' do
        apply_manifest(pp2, catch_changes: true)
      end

      pp3 = <<-EOS
        zabbix_host { 'test3.example.com':
          ipaddress        => '127.0.0.3',
          use_ip           => false,
          port             => 161,
          groups           => ['Virtual machines'],
          templates        => #{template_snmp},
          macros           => [],
          interfacetype    => 2,
          interfacedetails => {"version" => "2", "bulk" => "0", "community" => "public"},
        }
        zabbix_host { 'test4.example.com':
          ipaddress        => '127.0.0.4',
          use_ip           => false,
          port             => 161,
          groups           => ['Virtual machines'],
          templates        => #{template},
          macros           => [],
        }
      EOS

      it 'creates hosts with SNMP interface and details without errors' do
        apply_manifest(pp3, catch_failures: true)
      end

      it 'creates hosts with SNMP interface and details without changes' do
        apply_manifest(pp3, catch_changes: true)
      end

      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-EOS
          zabbix_host { 'test5.example.com':
            ipaddress   => '127.0.0.5',
            use_ip      => false,
            port        => 1051,
            groups      => ['Virtual machines'],
            templates   => #{template},
            macros      => [],
            tls_accept  => 'cert',
            tls_connect => 'cert',
            tls_issuer  => 'Zabbix.com',
            tls_subject => 'MyClientCertificate',
          }
          EOS
        end
      end

      let(:result_hosts) do
        zabbixapi(
          'localhost',
          'Admin',
          'zabbix',
          'host.get',
          selectParentTemplates: ['host'],
          selectInterfaces: %w[dns ip main port type useip details],
          selectGroups: ['name'],
          output: ['host', 'tls_accept', 'tls_connect', 'tls_issuer', 'tls_subject', '']
        ).result
      end

      context 'test1.example.com' do
        let(:test1) { result_hosts.select { |h| h['host'] == 'test1.example.com' }.first }

        it 'is created' do
          expect(test1['host']).to eq('test1.example.com')
        end

        it 'is in group TestgroupOne' do
          expect(test1['groups'].map { |g| g['name'] }).to eq(['TestgroupOne'])
        end

        it 'has a correct interface dns configured' do
          expect(test1['interfaces'][0]['dns']).to eq('test1.example.com')
        end

        it 'has a correct interface ip configured' do
          expect(test1['interfaces'][0]['ip']).to eq('127.0.0.1')
        end

        it 'has a correct interface main configured' do
          expect(test1['interfaces'][0]['main']).to eq('1')
        end

        it 'has a correct interface port configured' do
          expect(test1['interfaces'][0]['port']).to eq('10050')
        end

        it 'has a correct interface type configured' do
          expect(test1['interfaces'][0]['type']).to eq('1')
        end

        it 'has a correct interface useip configured' do
          expect(test1['interfaces'][0]['useip']).to eq('1')
        end

        it 'has templates attached' do
          expect(test1['parentTemplates'].map { |t| t['host'] }.sort).to eq(template.sort)
        end
      end

      context 'test2.example.com' do
        let(:test2) { result_hosts.select { |h| h['host'] == 'test2.example.com' }.first }

        it 'is created' do
          expect(test2['host']).to eq('test2.example.com')
        end

        it 'is in group Virtual machines' do
          expect(test2['groups'].map { |g| g['name'] }).to eq(['Virtual machines'])
        end

        it 'has a correct interface dns configured' do
          expect(test2['interfaces'][0]['dns']).to eq('test2.example.com')
        end

        it 'has a correct interface ip configured' do
          expect(test2['interfaces'][0]['ip']).to eq('127.0.0.2')
        end

        it 'has a correct interface main configured' do
          expect(test2['interfaces'][0]['main']).to eq('1')
        end

        it 'has a correct interface port configured' do
          expect(test2['interfaces'][0]['port']).to eq('1050')
        end

        it 'has a correct interface type configured' do
          expect(test2['interfaces'][0]['type']).to eq('1')
        end

        it 'has a correct interface useip configured' do
          expect(test2['interfaces'][0]['useip']).to eq('0')
        end

        it 'has templates attached' do
          expect(test2['parentTemplates'].map { |t| t['host'] }.sort).to eq(template.sort)
        end
      end

      context 'test3.example.com' do
        let(:test3) { result_hosts.select { |h| h['host'] == 'test3.example.com' }.first }

        it 'is created' do
          expect(test3['host']).to eq('test3.example.com')
        end

        it 'is in group Virtual machines' do
          expect(test3['groups'].map { |g| g['name'] }).to eq(['Virtual machines'])
        end

        it 'has a correct interface dns configured' do
          expect(test3['interfaces'][0]['dns']).to eq('test3.example.com')
        end

        it 'has a correct interface ip configured' do
          expect(test3['interfaces'][0]['ip']).to eq('127.0.0.3')
        end

        it 'has a correct interface main configured' do
          expect(test3['interfaces'][0]['main']).to eq('1')
        end

        it 'has a correct interface port configured' do
          expect(test3['interfaces'][0]['port']).to eq('161')
        end

        it 'has a correct interface type configured' do
          expect(test3['interfaces'][0]['type']).to eq('2')
        end

        it 'has a correct interface details configured' do
          expect(test3['interfaces'][0]['details']).to eq('version' => '2', 'bulk' => '0', 'community' => 'public')
        end

        it 'has a correct interface useip configured' do
          expect(test3['interfaces'][0]['useip']).to eq('0')
        end

        it 'has templates attached' do
          expect(test3['parentTemplates'].map { |t| t['host'] }.sort).to eq(template_snmp.sort)
        end
      end

      context 'test4.example.com' do
        let(:test4) { result_hosts.select { |h| h['host'] == 'test4.example.com' }.first }

        it 'is created' do
          expect(test4['host']).to eq('test4.example.com')
        end

        it 'is in group Virtual machines' do
          expect(test4['groups'].map { |g| g['name'] }).to eq(['Virtual machines'])
        end

        it 'has a correct interface dns configured' do
          expect(test4['interfaces'][0]['dns']).to eq('test4.example.com')
        end

        it 'has a correct interface ip configured' do
          expect(test4['interfaces'][0]['ip']).to eq('127.0.0.4')
        end

        it 'has a correct interface main configured' do
          expect(test4['interfaces'][0]['main']).to eq('1')
        end

        it 'has a correct interface port configured' do
          expect(test4['interfaces'][0]['port']).to eq('161')
        end

        it 'has a correct interface type configured' do
          expect(test4['interfaces'][0]['type']).to eq('1')
        end

        it 'has a correct interface details configured' do
          expect(test4['interfaces'][0]['details']).to eq([])
        end

        it 'has a correct interface useip configured' do
          expect(test4['interfaces'][0]['useip']).to eq('0')
        end

        it 'has templates attached' do
          expect(test4['parentTemplates'].map { |t| t['host'] }.sort).to eq(template.sort)
        end
      end

      context 'test5.example.com' do
        let(:test5) { result_hosts.select { |h| h['host'] == 'test5.example.com' }.first }

        it 'is created' do
          expect(test5['host']).to eq('test5.example.com')
        end

        it 'has a correct tls_accept configured' do
          expect(test5['tls_accept']).to eq('4')
        end

        it 'has a correct tls_connect configured' do
          expect(test5['tls_connect']).to eq('4')
        end

        it 'has a correct tls_issuer configured' do
          expect(test5['tls_issuer']).to eq('Zabbix.com')
        end

        it 'has a correct tls_subject configured' do
          expect(test5['tls_subject']).to eq('MyClientCertificate')
        end
      end
    end
  end
end
