require 'spec_helper'

describe 'zabbix::database::mysql' do
  let :node do
    'rspec.puppet.com'
  end
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end
      context 'with all defaults' do
        it 'fails' do
          is_expected.to raise_error(Puppet::Error, %r{We do not work.})
        end
      end
      path2 = if facts[:osfamily] == 'RedHat'
                # path to sql files on zabbix 2.4 on RedHat
                '/usr/share/doc/zabbix-*-mysql-2.4*/create'
              else
                # path to sql files on zabbix 2.4 on Debian
                '/usr/share/zabbix-*-mysql'
              end
      # path to sql files on zabbix 3.X on Debian and RedHat
      path3 = '/usr/share/doc/zabbix-*-mysql*'

      context 'when zabbix_type is server and zabbix version is 2.4' do
        let :params do
          {
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            database_password: 'zabbix-server',
            database_host: 'rspec.puppet.com',
            zabbix_type: 'server',
            zabbix_version: '2.4'
          }
        end

        it { is_expected.to contain_class('zabbix::database::mysql') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('zabbix_server_create.sql').with_command("cd #{path2} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < schema.sql && touch /etc/zabbix/.schema.done") }
        it { is_expected.to contain_exec('zabbix_server_images.sql').with_command("cd #{path2} && if [ -f images.sql.gz ]; then gunzip -f images.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < images.sql && touch /etc/zabbix/.images.done") }
        it { is_expected.to contain_exec('zabbix_server_data.sql').with_command("cd #{path2} && if [ -f data.sql.gz ]; then gunzip -f data.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < data.sql && touch /etc/zabbix/.data.done") }
        it { is_expected.to contain_class('zabbix::params') }
      end

      describe 'when zabbix_type is proxy and zabbix version is 2.4' do
        let :params do
          {
            database_name: 'zabbix-proxy',
            database_user: 'zabbix-proxy',
            database_password: 'zabbix-proxy',
            database_host: 'rspec.puppet.com',
            zabbix_type: 'proxy',
            zabbix_version: '2.4'
          }
        end
        it { is_expected.to contain_class('zabbix::database::mysql') }
        # this doesn't make much sense because the class requires other classes
        # it { should compile.with_all_deps }
        it { is_expected.to contain_exec('zabbix_proxy_create.sql').with_command("cd #{path2} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-proxy' -p'zabbix-proxy' -D 'zabbix-proxy' < schema.sql && touch /etc/zabbix/.schema.done") }
      end
      context 'when zabbix_type is server and zabbix version is 3.0' do
        let :params do
          {
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            database_password: 'zabbix-server',
            database_host: 'rspec.puppet.com',
            zabbix_type: 'server',
            zabbix_version: '3.0'
          }
        end
        it { is_expected.to contain_class('zabbix::database::mysql') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('zabbix_server_create.sql').with_command("cd #{path3} && if [ -f create.sql.gz ]; then gunzip -f create.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < create.sql && touch /etc/zabbix/.schema.done") }
        it { is_expected.to contain_exec('zabbix_server_images.sql').with_command('touch /etc/zabbix/.images.done') }
        it { is_expected.to contain_exec('zabbix_server_data.sql').with_command('touch /etc/zabbix/.data.done') }
      end

      describe 'when zabbix_type is proxy and zabbix version is 3.0' do
        let :params do
          {
            database_name: 'zabbix-proxy',
            database_user: 'zabbix-proxy',
            database_password: 'zabbix-proxy',
            database_host: 'rspec.puppet.com',
            zabbix_type: 'proxy',
            zabbix_version: '3.0'
          }
        end
        it { is_expected.to contain_class('zabbix::database::mysql') }
        # this doesn't make much sense because the class requires other classes
        # it { should compile.with_all_deps }
        it { is_expected.to contain_exec('zabbix_proxy_create.sql').with_command("cd #{path3} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-proxy' -p'zabbix-proxy' -D 'zabbix-proxy' < schema.sql && touch /etc/zabbix/.schema.done") }
      end
      context 'when zabbix_type is server and zabbix version is 3.2' do
        let :params do
          {
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            database_password: 'zabbix-server',
            database_host: 'rspec.puppet.com',
            zabbix_type: 'server',
            zabbix_version: '3.2'
          }
        end
        it { is_expected.to contain_class('zabbix::database::mysql') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('zabbix_server_create.sql').with_command("cd #{path3} && if [ -f create.sql.gz ]; then gunzip -f create.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < create.sql && touch /etc/zabbix/.schema.done") }
        it { is_expected.to contain_exec('zabbix_server_images.sql').with_command('touch /etc/zabbix/.images.done') }
        it { is_expected.to contain_exec('zabbix_server_data.sql').with_command('touch /etc/zabbix/.data.done') }
      end

      describe 'when zabbix_type is proxy and zabbix version is 3.2' do
        let :params do
          {
            database_name: 'zabbix-proxy',
            database_user: 'zabbix-proxy',
            database_password: 'zabbix-proxy',
            database_host: 'rspec.puppet.com',
            zabbix_type: 'proxy',
            zabbix_version: '3.2'
          }
        end
        it { is_expected.to contain_class('zabbix::database::mysql') }
        # this doesn't make much sense because the class requires other classes
        # it { should compile.with_all_deps }
        it { is_expected.to contain_exec('zabbix_proxy_create.sql').with_command("cd #{path3} && if [ -f schema.sql.gz ]; then gunzip -f schema.sql.gz ; fi && mysql -h 'rspec.puppet.com' -u 'zabbix-proxy' -p'zabbix-proxy' -D 'zabbix-proxy' < schema.sql && touch /etc/zabbix/.schema.done") }
      end
    end
  end
end
