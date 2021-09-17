require 'spec_helper'
require 'deep_merge'

describe 'zabbix::web' do
  let :node do
    'rspec.puppet.com'
  end

  let :params do
    {
      zabbix_url: 'zabbix.example.com'
    }
  end

  on_supported_os(baseline_os_hash).each do |os, facts|
    supported_versions.each do |zabbix_version|
      next if facts[:os]['name'] == 'windows'
      next if facts[:os]['name'] == 'Archlinux'
      next if facts[:os]['name'] == 'Gentoo'
      next if facts[:os]['name'] == 'Debian' && facts[:os]['release']['major'] == '9'
      next if facts[:os]['name'] == 'Ubuntu' && facts[:os]['release']['major'] == '16.04'
      # There are no zabbix 5.2 packages for Debian 11
      next if facts[:os]['name'] == 'Debian' && facts[:os]['release']['major'] == '11' && zabbix_version == '5.2'

      context "on #{os} " do
        let :facts do
          facts
        end

        context 'with all defaults' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/etc/zabbix/web').with_ensure('directory') }
        end

        describe 'with enforcing selinux' do
          let :params do
            {
              manage_selinux: true
            }
          end

          let :facts do
            facts.deep_merge(os: { selinux: { enabled: true } })
          end

          it { is_expected.to contain_selboolean('httpd_can_connect_zabbix').with('value' => 'on', 'persistent' => true) }
        end

        describe 'with false selinux' do
          let :params do
            {
              manage_selinux: false
            }
          end

          it { is_expected.not_to contain_selboolean('httpd_can_connect_zabbix') }
        end

        describe "with database_type as postgresql and zabbix_version #{zabbix_version}" do
          let :params do
            super().merge(database_type: 'postgresql')
            super().merge(zabbix_version: zabbix_version)
          end

          pgsqlpackage = case facts[:operatingsystem]
                         when 'Ubuntu'
                           if facts[:operatingsystemmajrelease] >= '16.04'
                             'php-pgsql'
                           else
                             'php5-pgsql'
                           end
                         when 'Debian'
                           if facts[:operatingsystemmajrelease].to_i >= 9
                             'php-pgsql'
                           else
                             'php5-pgsql'
                           end
                         else
                           'php5-pgsql'
                         end

          packages = if facts[:osfamily] == 'RedHat'
                       if facts[:operatingsystemmajrelease].to_i == 7 &&
                          !%w[VirtuozzoLinux OracleLinux Scientific].include?(facts[:os]['name']) &&
                          zabbix_version =~ %r{5\.[024]}
                         ['zabbix-web-pgsql-scl', 'zabbix-web']
                       else
                         ['zabbix-web-pgsql', 'zabbix-web']
                       end
                     else
                       ['zabbix-frontend-php', pgsqlpackage]
                     end

          packages.each do |package|
            it { is_expected.to contain_package(package) }
          end
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['TYPE'\]     = 'POSTGRESQL'}) }
        end

        describe 'with database_type as mysql', if: facts[:os]['release']['major'] != '7' && facts[:os]['family'] != 'RedHat' do
          let :params do
            super().merge(database_type: 'mysql')
          end

          mysqlpackage = case facts[:operatingsystem]
                         when 'Ubuntu'
                           if facts[:operatingsystemmajrelease] >= '16.04'
                             'php-mysql'
                           else
                             'php5-mysql'
                           end
                         when 'Debian'
                           if facts[:operatingsystemmajrelease].to_i >= 9
                             'php-mysql'
                           else
                             'php5-mysql'
                           end
                         else
                           'php5-mysql'
                         end

          packages = facts[:osfamily] == 'RedHat' ? ['zabbix-web-mysql', 'zabbix-web'] : ['zabbix-frontend-php', mysqlpackage]
          packages.each do |package|
            it { is_expected.to contain_package(package) }
          end
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['TYPE'\]     = 'MYSQL'}) }
        end

        it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php') }

        describe 'with parameter: web_config_owner' do
          let :params do
            super().merge(web_config_owner: 'apache')
          end

          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_owner('apache') }
        end

        describe 'with parameter: web_config_group' do
          let :params do
            super().merge(web_config_group: 'apache')
          end

          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_group('apache') }
        end

        describe 'when manage_resources is true' do
          let :params do
            super().merge(
              manage_resources: true
            )
          end

          it do
            is_expected.to contain_class('zabbix::resources::web').
              with_zabbix_url('zabbix.example.com').
              with_zabbix_user('Admin').
              with_zabbix_pass('zabbix').
              with_apache_use_ssl(false)
          end
          it do
            is_expected.to contain_file('/etc/zabbix/api.conf').
              with_ensure('file').
              with_owner('root').
              with_group('root').
              with_mode('0400').
              with_content(%r{zabbix_url     = zabbix\.example\.com}).
              with_content(%r{zabbix_user    = Admin}).
              with_content(%r{zabbix_pass    = zabbix}).
              with_content(%r{apache_use_ssl = false})
          end
          it { is_expected.to contain_package('zabbixapi').with_provider('puppet_gem') }
          it { is_expected.to contain_file('/etc/zabbix/imported_templates').with_ensure('directory') }
        end

        describe 'when manage_resources is false' do
          let :params do
            super().merge(manage_resources: false)
          end

          it { is_expected.not_to contain_class('zabbix::resources::web') }
        end

        describe 'with parameter: database_schema' do
          let :params do
            super().merge(database_schema: 'zabbix')
          end

          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['SCHEMA'\] = 'zabbix'}) }
        end

        describe 'with parameter: database_double_ieee754' do
          let :params do
            super().merge(database_double_ieee754: true)
          end

          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['DOUBLE_IEEE754'\] = 'true'}) }
        end

        it { is_expected.to contain_apache__vhost('zabbix.example.com').with_name('zabbix.example.com') }

        context 'with database_* settings' do
          let :params do
            super().merge(
              database_host: 'localhost',
              database_name: 'zabbix-server',
              database_user: 'zabbix-server',
              database_password: 'zabbix-server',
              zabbix_server: 'localhost',
              zabbix_listenport: '3306',
              zabbix_server_name: 'localhost',
              zabbix_version: '4.0'
            )
          end

          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['SERVER'\]   = 'localhost'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['DATABASE'\] = 'zabbix-server'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['USER'\]     = 'zabbix-server'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['PASSWORD'\] = 'zabbix-server'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$ZBX_SERVER      = 'localhost'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$ZBX_SERVER_PORT = '3306'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$ZBX_SERVER_NAME = 'localhost'}) }
        end

        describe 'with LDAP settings defined' do
          let :params do
            super().merge(
              ldap_cacert: '/etc/zabbix/ssl/ca.crt',
              ldap_clientcert: '/etc/zabbix/ssl/client.crt',
              ldap_clientkey: '/etc/zabbix/ssl/client.key',
              ldap_reqcert: 'allow'
            )
          end

          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^putenv\("LDAPTLS_CACERT=/etc/zabbix/ssl/ca.crt"\);}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^putenv\("LDAPTLS_CERT=/etc/zabbix/ssl/client.crt"\);}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^putenv\("LDAPTLS_KEY=/etc/zabbix/ssl/client.key"\);}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^putenv\("TLS_REQCERT=allow"\);}) }
        end

        describe 'with SAML settings defined' do
          let :params do
            super().merge(
              saml_sp_key: '/etc/zabbix/web/sp.key',
              saml_sp_cert: '/etc/zabbix/web/sp.cert',
              saml_idp_cert: '/etc/zabbix/web/idp.cert',
              saml_settings: {
                'strict' => true,
                'baseurl' => 'http://example.com/sp/',
                'security' => {
                  'signatureAlgorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha384',
                  'digestAlgorithm' => 'http://www.w3.org/2001/04/xmldsig-more#sha384',
                  'singleLogoutService' => {
                    'responseUrl' => '',
                  }
                }
              }
            )
          end

          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$SSO\['SP_KEY'\] = '/etc/zabbix/web/sp.key'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$SSO\['SP_CERT'\] = '/etc/zabbix/web/sp.cert'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$SSO\['IDP_CERT'\] = '/etc/zabbix/web/idp.cert'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$SSO\['SETTINGS'\] = \[ \n  "strict" => true,\n  "baseurl" => "http://example.com/sp/",\n  "security" => \[\n    "signatureAlgorithm" => "http://www.w3.org/2001/04/xmldsig-more#rsa-sha384",\n    "digestAlgorithm" => "http://www.w3.org/2001/04/xmldsig-more#sha384",\n    "singleLogoutService" => \[\n      "responseUrl" => ""\n    \]\n  \]\n\];}) }
        end
      end
    end
  end
end
