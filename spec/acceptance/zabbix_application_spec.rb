require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

describe 'zabbix_application type' do
  context 'create zabbix_application resources' do
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

        Zabbix_application {
          require => [ Service['zabbix-server'], Package['zabbixapi'], ],
        }

        zabbix_application { 'TestApplication1':
          template => 'Template OS Linux',
        }
      EOS

      shell('yum clean metadata') if fact('os.family') == 'RedHat'

      # Cleanup old database
      shell('/opt/puppetlabs/bin/puppet resource service zabbix-server ensure=stopped; /opt/puppetlabs/bin/puppet resource package zabbix-server-pgsql ensure=purged; rm -f /etc/zabbix/.*done; su - postgres -c "psql -c \'drop database if exists zabbix_server;\'"')

      apply_manifest(pp, expect_failures: true) # Error: Could not find a suitable provider for zabbix_application
      apply_manifest(pp, catch_failures: true)
    end

    let(:result_templates) do
      zabbixapi('localhost', 'Admin', 'zabbix', 'template.get', selectApplications: ['name'],
                                                                output: ['host']).result
    end

    context 'TestApplication1' do
      let(:template1) { result_templates.select { |t| t['host'] == 'Template OS Linux' }.first }

      it 'is attached to Template OS Linux' do
        expect(template1['applications'].map { |a| a['name'] }).to include('TestApplication1')
      end
    end
  end
end
