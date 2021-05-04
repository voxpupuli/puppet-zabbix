require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

# rubocop:disable RSpec/LetBeforeExamples
describe 'zabbix_host type', unless: default[:platform] =~ %r{(ubuntu-16.04|debian-9)-amd64} do
  %w[4.0 5.0 5.2].each do |zabbix_version|
    # 5.2 server packages are not available for RHEL 7
    next if zabbix_version == '5.2' && default[:platform] == 'el-7-x86_64'
    context "create zabbix_host resources with zabbix version #{zabbix_version}" do
      # This will deploy a running Zabbix setup (server, web, db) which we can
      # use for custom type tests

      template = case zabbix_version
                 when '4.0'
                   ['Template OS Linux', 'Template Module ICMP Ping']
                 when '5.0'
                   ['Template OS Linux by Zabbix agent', 'Template Module ICMP Ping']
                 else
                   ['Linux by Zabbix agent', 'ICMP Ping']
                 end

      pp1 = <<-EOS
        class { 'apache':
            mpm_module => 'prefork',
        }
        include apache::mod::php
        class { 'postgresql::globals':
          locale   => 'en_US.UTF-8',
          manage_package_repo => true,
          version => '12',
        }
        -> class { 'postgresql::server': }

        class { 'zabbix':
          zabbix_version   => "#{zabbix_version}",
          zabbix_url       => 'localhost',
          zabbix_api_user  => 'Admin',
          zabbix_api_pass  => 'zabbix',
          apache_use_ssl   => false,
          manage_resources => true,
          require          => [ Class['postgresql::server'], Class['apache'], ],
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

      let(:result_hosts) do
        zabbixapi('localhost', 'Admin', 'zabbix', 'host.get', selectParentTemplates: ['host'], selectInterfaces: %w[dns ip main port type useip], selectGroups: ['name'], output: ['host', '']).result
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
    end
  end
end
