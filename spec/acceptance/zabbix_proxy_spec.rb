require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

describe 'zabbix_proxy type' do
  context 'create zabbix_proxy resources' do
    it 'runs successfully' do
      # This will deploy a running Zabbix setup (server, web, db) which we can
      # use for custom type tests
      pp = <<-EOS
        class { 'apache':
            mpm_module => 'prefork',
        }
        include apache::mod::php
        include postgresql::server

        class { 'zabbix':
          zabbix_version   => '3.0', # zabbixapi gem doesn't currently support higher versions
          zabbix_url       => 'localhost',
          zabbix_api_user  => 'Admin',
          zabbix_api_pass  => 'zabbix',
          apache_use_ssl   => false,
          manage_resources => true,
          require          => [ Class['postgresql::server'], Class['apache'], ],
        }

        zabbix_proxy { 'ZabbixProxy1':
          ipaddress => '127.0.0.1',
          use_ip    => true,
          mode      => 0,
          port      => 10051,
          require   => [ Service['zabbix-server'], Package['zabbixapi'], ],
        }
        zabbix_proxy { 'ZabbixProxy2':
          ipaddress => '127.0.0.3',
          use_ip    => false,
          mode      => 1,
          port      => 10055,
          require   => [ Service['zabbix-server'], Package['zabbixapi'], ],
        }
      EOS

      shell('yum clean metadata') if fact('os.family') == 'RedHat'

      # Cleanup old database
      shell('/opt/puppetlabs/bin/puppet resource service zabbix-server ensure=stopped; /opt/puppetlabs/bin/puppet resource package zabbix-server-pgsql ensure=purged; rm -f /etc/zabbix/.*done; su - postgres -c "psql -c \'drop database if exists zabbix_server;\'"')

      apply_manifest(pp, catch_failures: true)
    end

    let(:result_proxies) do
      zabbixapi('localhost', 'Admin', 'zabbix', 'proxy.get', selectInterface: %w[dns ip port useip],
                                                             output: ['host']).result
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
end
