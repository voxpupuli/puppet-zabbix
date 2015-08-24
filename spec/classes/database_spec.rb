require 'spec_helper'

describe 'zabbix::database' do
  # Set some facts / params.
  let(:node) { 'rspec.puppet.com' }

  # Running an RedHat OS.
  context 'On a RedHat OS' do
    let :facts do
      {
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemrelease    => '6.5',
        :operatingsystemmajrelease => '6',
        :architecture              => 'x86_64',
        :lsbdistid                 => 'RedHat',
        :concat_basedir            => '/tmp'
      }
    end

    describe "database_type is postgresql, zabbix_type is server and is multiple host setup" do
        let :params do
            {
                :database_type    => 'postgresql',
                :database_name    => 'zabbix-server',
                :database_user    => 'zabbix-server',
                :zabbix_type      => 'server',
                :zabbix_web_ip    => '127.0.0.2',
                :zabbix_server_ip => '127.0.0.1',
            }
        end
        it { should contain_postgresql__server__db('zabbix-server').with_name('zabbix-server') }
        it { should contain_postgresql__server__db('zabbix-server').with_user('zabbix-server') }
        
        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_database('zabbix-server') }
        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_user('zabbix-server') }
        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_address('127.0.0.1/32') }

        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_database('zabbix-server') }
        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_user('zabbix-server') }
        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_address('127.0.0.2/32') }
    end

    describe "database_type is postgresql, zabbix_type is server and is single node setup" do
        let :params do
            {
                :database_type    => 'postgresql',
                :database_name    => 'zabbix-server',
                :database_user    => 'zabbix-server',
                :zabbix_type      => 'server',
                :zabbix_web_ip    => '127.0.0.1',
                :zabbix_server_ip => '127.0.0.1'
            }
        end
        it { should contain_postgresql__server__db('zabbix-server').with_name('zabbix-server') }
        it { should contain_postgresql__server__db('zabbix-server').with_user('zabbix-server') }
        
        it { should_not contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_database('zabbix-server') }
        it { should_not contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_user('zabbix-server') }
        it { should_not contain_postgresql__server__pg_hba_rule('Allow zabbix-server to access database').with_address('127.0.0.1/32') }

        it { should_not contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_database('zabbix-server') }
        it { should_not contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_user('zabbix-server') }
        it { should_not contain_postgresql__server__pg_hba_rule('Allow zabbix-web to access database').with_address('127.0.0.2/32') }
    end

    describe "database_type is postgresql, zabbix_type is proxy" do
        let :params do
            {
                :database_type   => 'postgresql',
                :database_name   => 'zabbix-proxy',
                :database_user   => 'zabbix-proxy',
                :zabbix_type     => 'proxy',
                :zabbix_proxy_ip => '127.0.0.1'
            }
        end
        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-proxy to access database').with_database('zabbix-proxy') }
        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-proxy to access database').with_user('zabbix-proxy') }
        it { should contain_postgresql__server__pg_hba_rule('Allow zabbix-proxy to access database').with_address('127.0.0.1/32') }
    end

    describe "database_type is mysql, zabbix_type is server and is multiple host setup" do
        let :params do
            {
                :database_type    => 'mysql',
                :database_name    => 'zabbix-server',
                :database_user    => 'zabbix-server',
                :zabbix_type      => 'server',
                :zabbix_web       => 'node1.example.com',
                :zabbix_server    => 'node0.example.com'
            }
        end
        it { should contain_mysql__db('zabbix-server').with_name('zabbix-server') }
        it { should contain_mysql__db('zabbix-server').with_user('zabbix-server') }
        it { should contain_mysql__db('zabbix-server').with_host('node0.example.com') }

        it { should contain_mysql_user('zabbix-server@node1.example.com').with_name('zabbix-server@node1.example.com') }
        it { should contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_name('zabbix-server@node1.example.com/zabbix-server.*') }
        it { should contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_table('zabbix-server.*') }
        it { should contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_user('zabbix-server@node1.example.com') }
    end

    describe "database_type is mysql, zabbix_type is server and is multiple host setup" do
        let :params do
            {
                :database_type    => 'mysql',
                :database_name    => 'zabbix-server',
                :database_user    => 'zabbix-server',
                :zabbix_type      => 'server',
                :zabbix_web       => 'node0.example.com',
                :zabbix_server    => 'node0.example.com'
            }
        end
        it { should contain_mysql__db('zabbix-server').with_name('zabbix-server') }
        it { should contain_mysql__db('zabbix-server').with_user('zabbix-server') }
        it { should contain_mysql__db('zabbix-server').with_host('node0.example.com') }

        it { should_not contain_mysql_user('zabbix-server@node1.example.com').with_name('zabbix-server@node1.example.com') }
        it { should_not contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_name('zabbix-server@node1.example.com/zabbix-server.*') }
        it { should_not contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_table('zabbix-server.*') }
        it { should_not contain_mysql_grant('zabbix-server@node1.example.com/zabbix-server.*').with_user('zabbix-server@node1.example.com') }
    end

    describe "database_type is mysql, zabbix_type is proxy" do
        let :params do
            {
                :database_type => 'mysql',
                :database_name => 'zabbix-proxy',
                :database_user => 'zabbix-proxy',
                :zabbix_type   => 'proxy',
                :zabbix_proxy  => 'node0.example.com'
            }
        end
        it { should contain_mysql__db('zabbix-proxy').with_name('zabbix-proxy') }
    end

    describe "database_type is mysql, zabbix_type is proxy" do
        let :params do
            {
                :database_type    => 'sqlite',
                :database_name    => 'zabbix-server',
                :database_user    => 'zabbix-server',
                :zabbix_type      => 'proxy',
                :zabbix_web       => 'node1.example.com',
                :zabbix_server    => 'node0.example.com'
            }
        end
        it { should contain_class('zabbix::database::sqlite') }
    end
  end
end

describe 'zabbix::database::postgresql' do
  # Set some facts / params.
  let(:node) { 'rspec.puppet.com' }

  # Running an RedHat OS.
  context 'On a RedHat OS' do
    let :facts do
      {
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemrelease    => '6.5',
        :operatingsystemmajrelease => '6',
        :architecture              => 'x86_64',
        :lsbdistid                 => 'RedHat',
        :concat_basedir            => '/tmp'
      }
    end

    describe "when zabbix_type is server" do
        let :params do
            {
                :database_name     => 'zabbix-server',
                :database_user     => 'zabbix-server',
                :database_password => 'zabbix-server',
                :database_host     => 'node01.example.com',
                :zabbix_type       => 'server',
                :zabbix_version    => '2.4'
            }
        end
        it { should contain_exec('update_pgpass').with_command('echo node01.example.com:5432:zabbix-server:zabbix-server:zabbix-server >> /root/.pgpass') }
        it { should contain_exec('zabbix_server_create.sql').with_command("cd /usr/share/doc/zabbix-*-pgsql-2.4*/create && if [ -f schema.sql.gz ]; then gunzip schema.sql.gz ; fi && psql -h 'node01.example.com' -U 'zabbix-server' -d 'zabbix-server' -f schema.sql && touch /etc/zabbix/.schema.done") }
        it { should contain_exec('zabbix_server_images.sql').with_command("cd /usr/share/doc/zabbix-*-pgsql-2.4*/create && if [ -f images.sql.gz ]; then gunzip images.sql.gz ; fi && psql -h 'node01.example.com' -U 'zabbix-server' -d 'zabbix-server' -f images.sql && touch /etc/zabbix/.images.done") }
        it { should contain_exec('zabbix_server_data.sql').with_command("cd /usr/share/doc/zabbix-*-pgsql-2.4*/create && if [ -f data.sql.gz ]; then gunzip data.sql.gz ; fi && psql -h 'node01.example.com' -U 'zabbix-server' -d 'zabbix-server' -f data.sql && touch /etc/zabbix/.data.done") }
    end

    describe "when zabbix_type is proxy" do
        let :params do
            {
                :database_name     => 'zabbix-proxy',
                :database_user     => 'zabbix-proxy',
                :database_password => 'zabbix-proxy',
                :database_host     => 'node01.example.com',
                :zabbix_type       => 'proxy',
                :zabbix_version    => '2.4'
            }
        end
        it { should contain_exec('update_pgpass').with_command('echo node01.example.com:5432:zabbix-proxy:zabbix-proxy:zabbix-proxy >> /root/.pgpass') }
        it { should contain_exec('zabbix_proxy_create.sql').with_command("cd /usr/share/doc/zabbix-*-pgsql-2.4*/create && if [ -f schema.sql.gz ]; then gunzip schema.sql.gz ; fi && psql -h 'node01.example.com' -U 'zabbix-proxy' -d 'zabbix-proxy' -f schema.sql && touch /etc/zabbix/.schema.done") }
    end

  end
end

describe 'zabbix::database::mysql' do
  # Set some facts / params.
  let(:node) { 'rspec.puppet.com' }

  # Running an RedHat OS.
  context 'On a RedHat OS' do
    let :facts do
      {
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemrelease    => '6.5',
        :operatingsystemmajrelease => '6',
        :architecture              => 'x86_64',
        :lsbdistid                 => 'RedHat',
        :concat_basedir            => '/tmp'
      }
    end

    describe "when zabbix_type is server" do
        let :params do
            {
                :database_name     => 'zabbix-server',
                :database_user     => 'zabbix-server',
                :database_password => 'zabbix-server',
                :database_host     => 'node01.example.com',
                :zabbix_type       => 'server',
                :zabbix_version    => '2.4'
            }
        end
        it { should contain_exec('zabbix_server_create.sql').with_command("cd /usr/share/doc/zabbix-*-mysql-2.4*/create && if [ -f schema.sql.gz ]; then gunzip schema.sql.gz ; fi && mysql -h 'node01.example.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < schema.sql && touch /etc/zabbix/.schema.done") }
        it { should contain_exec('zabbix_server_images.sql').with_command("cd /usr/share/doc/zabbix-*-mysql-2.4*/create && if [ -f images.sql.gz ]; then gunzip images.sql.gz ; fi && mysql -h 'node01.example.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < images.sql && touch /etc/zabbix/.images.done") }
        it { should contain_exec('zabbix_server_data.sql').with_command("cd /usr/share/doc/zabbix-*-mysql-2.4*/create && if [ -f data.sql.gz ]; then gunzip data.sql.gz ; fi && mysql -h 'node01.example.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < data.sql && touch /etc/zabbix/.data.done") }
    end

    describe "when zabbix_type is proxy" do
        let :params do
            {
                :database_name     => 'zabbix-proxy',
                :database_user     => 'zabbix-proxy',
                :database_password => 'zabbix-proxy',
                :database_host     => 'node01.example.com',
                :zabbix_type       => 'proxy',
                :zabbix_version    => '2.4'
            }
        end
        it { should contain_exec('zabbix_proxy_create.sql').with_command("cd /usr/share/doc/zabbix-*-mysql-2.4*/create && if [ -f schema.sql.gz ]; then gunzip schema.sql.gz ; fi && mysql -h 'node01.example.com' -u 'zabbix-proxy' -p'zabbix-proxy' -D 'zabbix-proxy' < schema.sql && touch /etc/zabbix/.schema.done") }
    end
  end
end
