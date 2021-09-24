require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

# rubocop:disable RSpec/LetBeforeExamples
describe 'zabbix_proxy type', unless: default[:platform] =~ %r{(ubuntu-16.04|debian-9)-amd64} do
  supported_versions.each do |zabbix_version|
    # 5.2 and 5.4 server packages are not available for RHEL 7
    next if zabbix_version == '5.2' && default[:platform] == 'el-7-x86_64'
    next if zabbix_version == '5.4' && default[:platform] == 'el-7-x86_64'
    # No Zabbix 5.2 packages on Debian 11
    next if zabbix_version == '5.2' && default[:platform] == 'debian-11-amd64'
    context "create zabbix_proxy resources with zabbix version #{zabbix_version}" do
      # This will deploy a running Zabbix setup (server, web, db) which we can
      # use for custom type tests
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
      it 'works with no error on first apply' do
        # Cleanup old database
        prepare_host

        apply_manifest(pp1, catch_failures: true)
      end
      it 'works with no error on second apply' do
        apply_manifest(pp1, catch_failures: true)
      end

      # setup proxies within zabbix
      pp2 = <<-EOS
      zabbix_proxy { 'ZabbixProxy1':
        mode => 0,
      }
      zabbix_proxy { 'ZabbixProxy2':
        ipaddress => '127.0.0.3',
        use_ip    => false,
        mode      => 1,
        port      => 10055,
      }
      EOS

      it 'works idempotently with no errors' do
        # Run it twice and test for idempotency
        apply_manifest(pp2, catch_failures: true)
        apply_manifest(pp2, catch_changes: true)
      end

      let(:result_proxies) do
        zabbixapi('localhost', 'Admin', 'zabbix', 'proxy.get', selectInterface: %w[dns ip port useip], output: ['host']).result
      end

      context 'ZabbixProxy1' do
        let(:proxy1) { result_proxies.select { |h| h['host'] == 'ZabbixProxy1' }.first }

        it 'is created' do
          expect(proxy1['host']).to eq('ZabbixProxy1')
        end

        it 'has no interfaces configured' do
          # Active proxies do not have interface
          expect(proxy1['interface']).to eq([])
        end
      end

      context 'ZabbixProxy2' do
        let(:proxy2) { result_proxies.select { |h| h['host'] == 'ZabbixProxy2' }.first }

        it 'is created' do
          expect(proxy2['host']).to eq('ZabbixProxy2')
        end

        it 'has a interfaces dns configured' do
          expect(proxy2['interface']['dns']).to eq('ZabbixProxy2')
        end
        it 'has a interfaces ip configured' do
          expect(proxy2['interface']['ip']).to eq('127.0.0.3')
        end
        it 'has a interfaces port configured' do
          expect(proxy2['interface']['port']).to eq('10055')
        end
        it 'has a interfaces useip configured' do
          expect(proxy2['interface']['useip']).to eq('0')
        end
      end
    end

    context 'update zabbix_proxy resources' do
      # This will update the Zabbix proxies created above by switching their configuration
      pp_update = <<-EOS
      zabbix_proxy { 'ZabbixProxy1':
        ipaddress => '127.0.0.3',
        use_ip    => false,
        mode      => 1,
        port      => 10055,
      }
      zabbix_proxy { 'ZabbixProxy2':
        mode => 0,
      }
      EOS

      it 'works idempotently with no errors' do
        # Run it twice and test for idempotency
        apply_manifest(pp_update, catch_failures: true)
        apply_manifest(pp_update, catch_changes: true)
      end

      let(:result_proxies) do
        zabbixapi('localhost', 'Admin', 'zabbix', 'proxy.get', selectInterface: %w[dns ip port useip], output: ['host']).result
      end

      context 'ZabbixProxy1' do
        let(:proxy1) { result_proxies.select { |h| h['host'] == 'ZabbixProxy1' }.first }

        it 'is created' do
          expect(proxy1['host']).to eq('ZabbixProxy1')
        end

        it 'has a interfaces dns configured' do
          expect(proxy1['interface']['dns']).to eq('ZabbixProxy1')
        end
        it 'has a interfaces ip configured' do
          expect(proxy1['interface']['ip']).to eq('127.0.0.3')
        end
        it 'has a interfaces port configured' do
          expect(proxy1['interface']['port']).to eq('10055')
        end
        it 'has a interfaces useip configured' do
          expect(proxy1['interface']['useip']).to eq('0')
        end
      end

      context 'ZabbixProxy2' do
        let(:proxy2) { result_proxies.select { |h| h['host'] == 'ZabbixProxy2' }.first }

        it 'is created' do
          expect(proxy2['host']).to eq('ZabbixProxy2')
        end

        it 'has no interfaces configured' do
          # Active proxies do not have interface
          expect(proxy2['interface']).to eq([])
        end
      end
    end

    context 'delete zabbix_proxy resources' do
      # This will delete the Zabbix proxies create above
      pp_delete = <<-EOS
      zabbix_proxy { 'ZabbixProxy1':
        ensure => absent,
      }
      zabbix_proxy { 'ZabbixProxy2':
        ensure => absent,
      }
      EOS

      it 'works idempotently with no errors' do
        # Run it twice and test for idempotency
        apply_manifest(pp_delete, catch_failures: true)
        apply_manifest(pp_delete, catch_changes: true)
      end

      let(:result_proxies) do
        zabbixapi('localhost', 'Admin', 'zabbix', 'proxy.get', selectInterface: %w[dns ip port useip], output: ['host']).result
      end

      context 'ZabbixProxy1' do
        let(:proxy1) { result_proxies.select { |h| h['host'] == 'ZabbixProxy1' }.first }

        it "doesn't exist" do
          expect(proxy1).to eq(nil)
        end
      end

      context 'ZabbixProxy2' do
        let(:proxy2) { result_proxies.select { |h| h['host'] == 'ZabbixProxy2' }.first }

        it "doesn't exist" do
          expect(proxy2).to eq(nil)
        end
      end
    end
  end
end
