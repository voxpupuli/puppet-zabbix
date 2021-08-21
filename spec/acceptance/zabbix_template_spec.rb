require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

describe 'zabbix_template type', unless: default[:platform] =~ %r{(ubuntu-16.04|debian-9)-amd64} do
  supported_versions.each do |zabbix_version|
    # 5.2 and 5.4 server packages are not available for RHEL 7
    next if zabbix_version == '5.2' && default[:platform] == 'el-7-x86_64'
    next if zabbix_version == '5.4' && default[:platform] == 'el-7-x86_64'
    # No Zabbix 5.2 packages on Debian 11
    next if zabbix_version == '5.2' && default[:platform] == 'debian-11-amd64'
    context "create zabbix_template resources with zabbix version #{zabbix_version}" do
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
          zabbix_template { 'TestTemplate1':
            template_source => '/root/TestTemplate1.xml',
            zabbix_version  => "#{zabbix_version}",
          }
      EOS

      shell("echo '<?xml version=\"1.0\" encoding=\"UTF-8\"?><zabbix_export><version>4.0</version><date>2018-12-13T15:00:46Z</date><groups><group><name>Templates/Applications</name></group></groups><templates><template><template>TestTemplate1</template><name>TestTemplate1</name><description/><groups><group><name>Templates/Applications</name></group></groups><applications/><items/><discovery_rules/><macros/><templates/><screens/></template></templates></zabbix_export>' > /root/TestTemplate1.xml")

      # setup zabbix. Apache module isn't idempotent and requires a second run
      it 'works with no error on the first apply' do
        # Cleanup old database
        prepare_host

        apply_manifest(pp1, catch_failures: true)
      end

      it 'works with no error on the second apply' do
        apply_manifest(pp1, catch_failures: true)
      end

      it 'works with no error on the third apply' do
        apply_manifest(pp2, catch_failures: true)
      end
    end

    let(:result_templates) do
      # selectApplications parameter was removed in Zabbix 5.4
      if zabbix_version =~ %r{5\.[^4]}
        zabbixapi('localhost', 'Admin', 'zabbix', 'template.get', selectApplications: ['name'], output: ['host']).result
      else
        zabbixapi('localhost', 'Admin', 'zabbix', 'template.get', output: ['host']).result
      end
    end

    context 'TestTemplate1' do
      let(:template1) { result_templates.select { |t| t['host'] == 'TestTemplate1' }.first }

      it 'is created' do
        expect(template1['host']).to eq('TestTemplate1')
      end
    end
  end
end
