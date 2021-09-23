require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

describe 'zabbix_application type', unless: default[:platform] =~ %r{(ubuntu-16.04|debian-9)-amd64} do
  supported_versions.each do |zabbix_version|
    # 5.2 and 5.4 server packages are not available for RHEL 7
    next if zabbix_version == '5.2' && default[:platform] == 'el-7-x86_64'
    # Application API was removed in Zabbix 5.4
    next if zabbix_version == '5.4'
    # No Zabbix 5.2 packages on Debian 11
    next if zabbix_version == '5.2' && default[:platform] == 'debian-11-amd64'

    template = case zabbix_version
               when '4.0'
                 'Template OS Linux'
               when '5.0'
                 'Template OS Linux by Zabbix agent'
               else
                 'Linux by Zabbix agent'
               end

    context "create zabbix_application resources with zabbix version #{zabbix_version}" do
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

      pp2 = <<-EOS
        zabbix_application { 'TestApplication1':
          template => "#{template}",
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

      # configure the applications within zabbix
      it 'works with no error on the third apply' do
        apply_manifest(pp2, catch_failures: true)
      end
      it 'works without changes on the fourth apply' do
        apply_manifest(pp2, catch_changes: true)
      end
    end

    let(:result_templates) do
      zabbixapi('localhost', 'Admin', 'zabbix', 'template.get', selectApplications: ['name'], output: ['host']).result
    end

    context 'TestApplication1' do
      let(:template1) { result_templates.select { |t| t['host'] == template }.first }

      it "is attached to #{template}" do
        expect(template1['applications'].map { |a| a['name'] }).to include('TestApplication1')
      end
    end
  end
end
