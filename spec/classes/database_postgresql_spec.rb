# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix::database::postgresql' do
  let :node do
    'rspec.puppet.com'
  end

  let :pre_condition do
    'include postgresql::server'
  end

  on_supported_os(baseline_os_hash).each do |os, facts|
    next if facts[:os]['name'] == 'windows'

    context "on #{os}" do
      let :facts do
        facts
      end

      supported_versions.each do |zabbix_version|
        path = case facts[:os]['name']
               when 'CentOS', 'RedHat', 'OracleLinux', 'VirtuozzoLinux'
                 # Path on RedHat
                 if Puppet::Util::Package.versioncmp(zabbix_version, '5.4') >= 0
                   '/usr/share/doc/zabbix-sql-scripts/postgresql/'
                 else
                   "/usr/share/doc/zabbix-*-pgsql-#{zabbix_version}*/"
                 end
               else
                 # Path on Debian
                 if Puppet::Util::Package.versioncmp(zabbix_version, '5.4') >= 0
                   '/usr/share/doc/zabbix-sql-scripts/postgresql/'
                 else
                   '/usr/share/doc/zabbix-*-pgsql'
                 end
               end

        sql_server = case zabbix_version
                     when '6.0'
                       'server.sql'
                     else
                       'create.sql'
                     end

        describe "when zabbix_type is server and version is #{zabbix_version}" do
          let :params do
            {
              database_name: 'zabbix-server',
              database_user: 'zabbix-server',
              database_password: 'zabbix-server',
              database_host: 'node01.example.com',
              database_port: 5432,
              zabbix_type: 'server',
              zabbix_version: zabbix_version
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_exec('update_pgpass').with_command('echo node01.example.com:5432:zabbix-server:zabbix-server:zabbix-server >> /root/.pgpass') }
          it { is_expected.to contain_exec('zabbix_server_create.sql').with_command("cd #{path} && if [ -f #{sql_server}.gz ]; then gunzip -f #{sql_server}.gz ; fi && psql -h 'node01.example.com' -U 'zabbix-server' -p 5432 -d 'zabbix-server' -f #{sql_server} && touch /etc/zabbix/.schema.done") }
          it { is_expected.to contain_exec('zabbix_server_images.sql').with_command('touch /etc/zabbix/.images.done') }
          it { is_expected.to contain_exec('zabbix_server_data.sql').with_command('touch /etc/zabbix/.data.done') }
          it { is_expected.to contain_file('/root/.pgpass') }
          it { is_expected.to contain_class('zabbix::params') }
        end

        describe "when zabbix_type is server and version is #{zabbix_version} and no port is defined" do
          let :params do
            {
              database_name: 'zabbix-server',
              database_user: 'zabbix-server',
              database_password: 'zabbix-server',
              database_host: 'node01.example.com',
              zabbix_type: 'server',
              zabbix_version: zabbix_version
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_exec('update_pgpass').with_command('echo node01.example.com:5432:zabbix-server:zabbix-server:zabbix-server >> /root/.pgpass') }
          it { is_expected.to contain_exec('zabbix_server_create.sql').with_command("cd #{path} && if [ -f #{sql_server}.gz ]; then gunzip -f #{sql_server}.gz ; fi && psql -h 'node01.example.com' -U 'zabbix-server' -d 'zabbix-server' -f #{sql_server} && touch /etc/zabbix/.schema.done") }
          it { is_expected.to contain_exec('zabbix_server_images.sql').with_command('touch /etc/zabbix/.images.done') }
          it { is_expected.to contain_exec('zabbix_server_data.sql').with_command('touch /etc/zabbix/.data.done') }
          it { is_expected.to contain_file('/root/.pgpass') }
          it { is_expected.to contain_class('zabbix::params') }
        end

        describe "when zabbix_type is proxy and version is #{zabbix_version}" do
          let :params do
            {
              database_name: 'zabbix-proxy',
              database_user: 'zabbix-proxy',
              database_password: 'zabbix-proxy',
              database_host: 'node01.example.com',
              database_port: 5432,
              zabbix_type: 'proxy',
              zabbix_version: zabbix_version
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_exec('update_pgpass').with_command('echo node01.example.com:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /root/.pgpass') }

          if Puppet::Util::Package.versioncmp(zabbix_version, '6.0') < 0
            it { is_expected.to contain_exec('zabbix_proxy_create.sql').with_command("cd #{path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && psql -h 'node01.example.com' -U 'zabbix-proxy' -p 5432 -d 'zabbix-proxy' -f schema.sql && touch /etc/zabbix/.schema.done") }
          else
            it { is_expected.to contain_exec('zabbix_proxy_create.sql').with_command("cd #{path} && psql -h 'node01.example.com' -U 'zabbix-proxy' -p 5432 -d 'zabbix-proxy' -f proxy.sql && touch /etc/zabbix/.schema.done") }
          end
          it { is_expected.to contain_class('zabbix::params') }
        end

        describe "when zabbix_type is proxy and version is #{zabbix_version} and no port is defined" do
          let :params do
            {
              database_name: 'zabbix-proxy',
              database_user: 'zabbix-proxy',
              database_password: 'zabbix-proxy',
              database_host: 'node01.example.com',
              zabbix_type: 'proxy',
              zabbix_version: zabbix_version
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_exec('update_pgpass').with_command('echo node01.example.com:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /root/.pgpass') }

          if Puppet::Util::Package.versioncmp(zabbix_version, '6.0') < 0
            it { is_expected.to contain_exec('zabbix_proxy_create.sql').with_command("cd #{path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && psql -h 'node01.example.com' -U 'zabbix-proxy' -d 'zabbix-proxy' -f schema.sql && touch /etc/zabbix/.schema.done") }
          else
            it { is_expected.to contain_exec('zabbix_proxy_create.sql').with_command("cd #{path} && psql -h 'node01.example.com' -U 'zabbix-proxy' -d 'zabbix-proxy' -f proxy.sql && touch /etc/zabbix/.schema.done") }
          end

          it { is_expected.to contain_class('zabbix::params') }
        end
      end
    end
  end
end
