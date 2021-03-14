require 'spec_helper'

describe 'zabbix::database::mysql' do
  let :node do
    'rspec.puppet.com'
  end

  let :pre_condition do
    "include 'mysql::server'"
  end

  on_supported_os.each do |os, facts|
    next if facts[:os]['name'] == 'windows'
    context "on #{os} " do
      let :facts do
        facts
      end

      context 'with all defaults' do
        it 'fails' do
          is_expected.not_to compile.with_all_deps
        end
      end
      # path to sql files on zabbix 3.X on Debian and RedHat
      path = '/usr/share/doc/zabbix-*-mysql*'

      %w[4.0 5.0 5.2].each do |zabbix_version|
        context "when zabbix_type is server and zabbix version is #{zabbix_version}" do
          let :params do
            {
              database_name: 'zabbix-server',
              database_user: 'zabbix-server',
              database_password: 'zabbix-server',
              database_host: 'rspec.puppet.com',
              zabbix_type: 'server',
              zabbix_version: zabbix_version
            }
          end

          it { is_expected.to contain_class('zabbix::database::mysql') }
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_exec('zabbix_server_create.sql').with_command("cd #{path} && if [ -f create.sql.gz ]; then gunzip -f create.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < create.sql && touch /etc/zabbix/.schema.done") }
          it { is_expected.to contain_exec('zabbix_server_images.sql').with_command('touch /etc/zabbix/.images.done') }
          it { is_expected.to contain_exec('zabbix_server_data.sql').with_command('touch /etc/zabbix/.data.done') }

          describe "when zabbix_type is proxy and zabbix version is #{zabbix_version}" do
            let :params do
              {
                database_name: 'zabbix-proxy',
                database_user: 'zabbix-proxy',
                database_password: 'zabbix-proxy',
                database_host: 'rspec.puppet.com',
                zabbix_type: 'proxy',
                zabbix_version: zabbix_version
              }
            end

            it { is_expected.to contain_class('zabbix::database::mysql') }
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_exec('zabbix_proxy_create.sql').with_command("cd #{path} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-proxy' -p'zabbix-proxy' -D 'zabbix-proxy' < schema.sql && touch /etc/zabbix/.schema.done") }
          end
        end
      end
    end
  end
end
