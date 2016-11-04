require 'spec_helper'

def package_provider_for_gems
  Puppet.version =~ %r{^4} ? 'puppet_gem' : 'gem'
end

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
    context "on #{os} " do
      let :facts do
        facts
      end

      if facts[:osfamily] == 'Archlinux'
        context 'with all defaults' do
          it { is_expected.not_to compile }
        end
      else
        context 'with all defaults' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/etc/zabbix/web').with_ensure('directory') }
        end

        describe 'with enforcing selinux' do
          let :facts do
            super().merge(selinux_config_mode: 'enforcing')
          end
          if facts[:osfamily] == 'RedHat'
            it { is_expected.to contain_selboolean('httpd_can_connect_zabbix').with('value' => 'on', 'persistent' => true) }
          else
            it { is_expected.not_to contain_selboolean('httpd_can_connect_zabbix') }
          end
        end

        %w(permissive disabled).each do |mode|
          describe "with #{mode} selinux" do
            let :facts do
              super().merge(selinux_config_mode: mode)
            end
            it { is_expected.not_to contain_selboolean('httpd_can_connect_zabbix') }
          end
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

          it { is_expected.to contain_class('zabbix::resources::web') }
          it { is_expected.to contain_package('zabbixapi').that_requires('Class[ruby::dev]').with_provider(package_provider_for_gems) }
          it { is_expected.to contain_class('ruby::dev') }
          it { is_expected.to contain_file('/etc/zabbix/imported_templates').with_ensure('directory') }
        end

        describe 'when manage_resources and is_pe are true' do
          let :facts do
            super().merge(
              is_pe: true,
              pe_version: '3.7.0'
            )
          end

          let :params do
            super().merge(manage_resources: true)
          end

          it { is_expected.to contain_package('zabbixapi').with_provider('pe_puppetserver_gem') }
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
              zabbix_server: 'localhost'
            )
          end

          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['SERVER'\]   = 'localhost'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['DATABASE'\] = 'zabbix-server'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['USER'\]     = 'zabbix-server'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$DB\['PASSWORD'\] = 'zabbix-server'}) }
          it { is_expected.to contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(%r{^\$ZBX_SERVER      = 'localhost'}) }
        end
      end
    end
  end
end
