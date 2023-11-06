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

      let :params do
        {
          database_host: 'node01.example.com',
        }
      end

      let :expected_environment do
        [
          'PGHOST=node01.example.com',
        ]
      end

      supported_versions.each do |zabbix_version|
        path = if facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'] == '7'
                 # Path on EL7
                 if Puppet::Util::Package.versioncmp(zabbix_version, '6.0') >= 0
                   '/usr/share/zabbix-sql-scripts/postgresql/'
                 else
                   "/usr/share/doc/zabbix-*-pgsql-#{zabbix_version}*/"
                 end
               # Path on Debian and EL8
               elsif Puppet::Util::Package.versioncmp(zabbix_version, '6.0') >= 0
                 '/usr/share/zabbix-sql-scripts/postgresql/'
               else
                 '/usr/share/doc/zabbix-*-pgsql'
               end

        sql_server = case zabbix_version
                     when '6.0'
                       'server.sql'
                     else
                       'create.sql'
                     end

        describe "when version is #{zabbix_version}" do
          let(:params) { super().merge(zabbix_version: zabbix_version) }

          describe 'when zabbix_type is server' do
            let(:params) do
              super().merge(
                database_name: 'zabbix-server',
                database_user: 'zabbix-server',
                database_password: 'zabbix-server',
                zabbix_type: 'server'
              )
            end
            let(:expected_environment) do
              super() + [
                'PGPORT=5432',
                'PGUSER=zabbix-server',
                'PGPASSWORD=zabbix-server',
                'PGDATABASE=zabbix-server',
              ]
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_exec('zabbix_create.sql').with_command("cd #{path} && if [ -f #{sql_server}.gz ]; then zcat #{sql_server}.gz | psql ; else psql -f #{sql_server}; fi && touch /etc/zabbix/.schema.done").with_environment(expected_environment) }
            it { is_expected.to contain_class('zabbix::params') }

            describe 'with custom port is defined' do
              let(:params) { super().merge(database_port: 6432) }

              it { is_expected.to compile.with_all_deps }
              it { is_expected.to contain_exec('zabbix_create.sql').with_environment(expected_environment.map { |v| v.start_with?('PGPORT=') ? 'PGPORT=6432' : v }) }
              it { is_expected.to contain_class('zabbix::params') }
            end
          end

          describe 'when zabbix_type is proxy' do
            let :params do
              super().merge(
                database_name: 'zabbix-proxy',
                database_user: 'zabbix-proxy',
                database_password: 'zabbix-proxy',
                zabbix_type: 'proxy'
              )
            end
            let(:expected_environment) do
              super() + [
                'PGPORT=5432',
                'PGUSER=zabbix-proxy',
                'PGPASSWORD=zabbix-proxy',
                'PGDATABASE=zabbix-proxy',
              ]
            end

            it { is_expected.to compile.with_all_deps }

            if Puppet::Util::Package.versioncmp(zabbix_version, '6.0') < 0
              it { is_expected.to contain_exec('zabbix_create.sql').with_command("cd #{path} && if [ -f schema.sql.gz ]; then zcat schema.sql.gz | psql ; else psql -f schema.sql; fi && touch /etc/zabbix/.schema.done").with_environment(expected_environment) }
            else
              it { is_expected.to contain_exec('zabbix_create.sql').with_command("cd #{path} && if [ -f proxy.sql.gz ]; then zcat proxy.sql.gz | psql ; else psql -f proxy.sql; fi && touch /etc/zabbix/.schema.done").with_environment(expected_environment) }
            end
            it { is_expected.to contain_class('zabbix::params') }

            describe 'with a custom port' do
              let(:params) { super().merge(database_port: 6432) }

              it { is_expected.to compile.with_all_deps }
              it { is_expected.to contain_exec('zabbix_create.sql').with_environment(expected_environment.map { |v| v.start_with?('PGPORT=') ? 'PGPORT=6432' : v }) }
              it { is_expected.to contain_class('zabbix::params') }
            end
          end
        end
      end
    end
  end
end
