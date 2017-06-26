require 'spec_helper'

describe 'zabbix::database' do
  let :node do
    'rspec.puppet.com'
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      describe 'database_type is postgresql, zabbix_type is server and is multiple host setup' do
        let :params do
          {
            database_type: 'postgresql',
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            zabbix_type: 'server',
            zabbix_web_ip: '127.0.0.2',
            zabbix_server_ip: '127.0.0.1',
            database_host_ip: '127.0.0.3'
          }
        end

        it { is_expected.to contain_postgresql__server__db('zabbix-server').with_name('zabbix-server') }
        it { is_expected.to contain_postgresql__server__db('zabbix-server').with_user('zabbix-server') }

        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_database('zabbix-server') }
        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_user('zabbix-server') }
        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_address('127.0.0.1/32') }

        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_database('zabbix-server') }
        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_user('zabbix-server') }
        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_address('127.0.0.2/32') }
        it { is_expected.to contain_class('zabbix::params') }
      end

      describe 'database_type is postgresql, zabbix_type is server and is single node setup' do
        let :params do
          {
            database_type: 'postgresql',
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            zabbix_type: 'server',
            zabbix_web_ip: '127.0.0.1',
            zabbix_server_ip: '127.0.0.1'
          }
        end

        it { is_expected.to contain_postgresql__server__db('zabbix-server').with_name('zabbix-server') }
        it { is_expected.to contain_postgresql__server__db('zabbix-server').with_user('zabbix-server') }

        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_database('zabbix-server') }
        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_user('zabbix-server') }
        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_address('127.0.0.1/32') }

        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_database('zabbix-server') }
        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_user('zabbix-server') }
        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_address('127.0.0.2/32') }
        it { is_expected.to contain_class('zabbix::params') }
      end

      describe 'database_type is postgresql, zabbix_type is server and zabbbix_server and a zabbix_web in the some server but zabbix_database is on other server' do
        let :params do
          {
            database_type: 'postgresql',
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            zabbix_type: 'server',
            zabbix_web_ip: '127.0.0.1',
            zabbix_server_ip: '127.0.0.1',
            database_host_ip: '127.0.0.2'
          }
        end

        it { is_expected.to contain_postgresql__server__db('zabbix-server').with_name('zabbix-server') }
        it { is_expected.to contain_postgresql__server__db('zabbix-server').with_user('zabbix-server') }

        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_database('zabbix-server') }
        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_user('zabbix-server') }
        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_address('127.0.0.1/32') }

        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_database('zabbix-server') }
        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_user('zabbix-server') }
        it { is_expected.not_to contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_address('127.0.0.2/32') }
        it { is_expected.to contain_class('zabbix::params') }
      end

      describe 'database_type is postgresql, zabbix_type is proxy' do
        let :params do
          {
            database_type: 'postgresql',
            database_name: 'zabbix-proxy',
            database_user: 'zabbix-proxy',
            zabbix_type: 'proxy',
            zabbix_proxy_ip: '127.0.0.1'
          }
        end

        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-proxy to access database').with_database('zabbix-proxy') }
        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-proxy to access database').with_user('zabbix-proxy') }
        it { is_expected.to contain_postgresql__server__pg_hba_rule('Allow zabbix-proxy to access database').with_address('127.0.0.1/32') }
        it { is_expected.to contain_postgresql__server__db('zabbix-proxy') }
        it { is_expected.to contain_class('zabbix::params') }
      end

      describe 'database_type is mysql, zabbix_type is server and is multiple host setup' do
        let :params do
          {
            database_type: 'mysql',
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            zabbix_type: 'server',
            zabbix_web: 'node1.example.com',
            zabbix_server: 'node0.example.com'
          }
        end

        it { is_expected.to contain_mysql__db('zabbix-server').with_name('zabbix-server') }
        it { is_expected.to contain_mysql__db('zabbix-server').with_user('zabbix-server') }
        it { is_expected.to contain_mysql__db('zabbix-server').with_host('node0.example.com') }

        it { is_expected.to contain_mysql_user('zabbix-server@node1.example.com').with_name('zabbix-server@node1.example.com') }
        it { is_expected.to contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_name('zabbix-server@node1.example.com/zabbix-server.*') }
        it { is_expected.to contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_table('zabbix-server.*') }
        it { is_expected.to contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_user('zabbix-server@node1.example.com') }
        it { is_expected.to contain_class('zabbix::params') }
      end

      describe 'database_type is mysql, zabbix_type is server and is a single host setup' do
        let :params do
          {
            database_type: 'mysql',
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            zabbix_type: 'server',
            zabbix_web: 'node0.example.com',
            zabbix_server: 'node0.example.com'
          }
        end

        it { is_expected.to contain_mysql__db('zabbix-server').with_name('zabbix-server') }
        it { is_expected.to contain_mysql__db('zabbix-server').with_user('zabbix-server') }
        it { is_expected.to contain_mysql__db('zabbix-server').with_host('node0.example.com') }

        it { is_expected.not_to contain_mysql_user('zabbix-server@node1.example.com').with_name('zabbix-server@node1.example.com') }
        it { is_expected.not_to contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_name('zabbix-server@node1.example.com/zabbix-server.*') }
        it { is_expected.not_to contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_table('zabbix-server.*') }
        it { is_expected.not_to contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_user('zabbix-server@node1.example.com') }
        it { is_expected.to contain_class('zabbix::params') }
      end

      describe 'database_type is mysql, zabbix_type is proxy and is a single host setup' do
        let :params do
          {
            database_type: 'mysql',
            database_name: 'zabbix-proxy',
            database_user: 'zabbix-proxy',
            zabbix_type: 'proxy',
            zabbix_proxy: 'node0.example.com'
          }
        end

        it { is_expected.to contain_mysql__db('zabbix-proxy').with_name('zabbix-proxy') }
        it { is_expected.to contain_class('zabbix::params') }
      end

      describe 'database_type is sqlite, zabbix_type is proxy and is a multiple host setup' do
        let :params do
          {
            database_type: 'sqlite',
            database_name: 'zabbix-server',
            database_user: 'zabbix-server',
            zabbix_type: 'proxy',
            zabbix_web: 'node0.example.com',
            zabbix_server: 'node1.example.com'
          }
        end

        it { is_expected.to contain_class('zabbix::database::sqlite') }
        it { is_expected.to contain_class('zabbix::params') }
      end
    end
  end
end
