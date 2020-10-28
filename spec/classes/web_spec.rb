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

  on_supported_os.each do |os, facts|
    next if facts[:os]['name'] == 'windows'
    context "on #{os} " do
      let :facts do
        facts
      end

      if facts[:osfamily] == 'Archlinux' || facts[:osfamily] == 'Gentoo'
        context 'with all defaults' do
          it { is_expected.not_to compile }
        end
      else
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

        describe 'with database_type as postgresql' do
          let :params do
            super().merge(database_type: 'postgresql')
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

          if facts[:osfamily] == 'RedHat'
            if facts[:operatingsystemmajrelease] == 7 and :zabbix_version >= 5
              packages = ['zabbix-web-pgsql-scl', 'zabbix-web']
            else
              packages = ['zabbix-web-pgsql', 'zabbix-web']
            end
          else
            packages = ['zabbix-frontend-php', pgsqlpackage]
          end
          packages.each do |package|
            it { is_expected.to contain_package(package) }
          end
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['TYPE'\]     = 'POSTGRESQL'}) }
        end

        describe 'with database_type as mysql' do
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

          if facts[:osfamily] == 'RedHat'
            if facts[:operatingsystemmajrelease] == 7 and :zabbix_version >= 5
              packages = ['zabbix-web-pgsql-scl', 'zabbix-web']
            else
              packages = ['zabbix-web-pgsql', 'zabbix-web']
            end
          else
            packages = ['zabbix-frontend-php', mysqlpackage]
          end
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
              zabbix_server_name: 'localhost'
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
        if facts[:osfamily] == 'RedHat'
          if facts[:operatingsystemmajrelease].to_i == 7
            context 'when zabbix_version is 5.0 and OS is CentOS 7 validate php-fpm.d configuration'
              let :params do
                super().merge(
                  apache_php_max_execution_time: '300',
                  apache_php_memory_limit: '128M',
                  apache_php_post_max_size: '16M',
                  apache_php_upload_max_filesize: '2M',
                  apache_php_max_input_time: '300',
                  apache_php_always_populate_raw_post_data: '-1',
                  apache_php_max_input_vars: 10000,
                  zabbix_timezone: 'America/New_York',
                  zabbix_version: '5.0'
                )
              end

              it { is_expected.to contain_file('/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf').with_content(%r{^php_value\[max_execution_time\] = 300}) }
              it { is_expected.to contain_file('/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf').with_content(%r{^php_value\[memory_limit\] = 128M}) }
              it { is_expected.to contain_file('/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf').with_content(%r{^php_value\[post_max_size\] = 128M}) }
              it { is_expected.to contain_file('/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf').with_content(%r{^php_value\[upload_max_filesize\] = 2M}) }
              it { is_expected.to contain_file('/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf').with_content(%r{^php_value\[max_input_vars\] = 10000}) }
              it { is_expected.to contain_file('/etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf').with_content(%r{^php_value\[date\.timezone\] = America/New_York}) }
            end
          end
      end
    end
  end
end
