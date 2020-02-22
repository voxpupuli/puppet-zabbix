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
                           if facts[:operatingsystemmajrelease] >= '9'
                             'php-pgsql'
                           else
                             'php5-pgsql'
                           end
                         else
                           'php5-pgsql'
                         end

          packages = facts[:osfamily] == 'RedHat' ? ['zabbix-web-pgsql', 'zabbix-web'] : ['zabbix-frontend-php', pgsqlpackage]
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
                           if facts[:operatingsystemmajrelease] >= '9'
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
      end
    end
  end
end
