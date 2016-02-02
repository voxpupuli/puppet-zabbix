require 'spec_helper'

describe 'zabbix::database::mysql' do
  let (:node) { 'rspec.puppet.com' }

  context 'On RedHat 6.5' do
    let (:facts) do
      {
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemrelease    => '6.5',
        :operatingsystemmajrelease => '6',
        :architecture              => 'x86_64',
        :lsbdistid                 => 'RedHat',
        :concat_basedir            => '/tmp',
      }
    end

    describe "when zabbix_type is server" do
      let (:params) do
        {
          :database_name     => 'zabbix-server',
          :database_user     => 'zabbix-server',
          :database_password => 'zabbix-server',
          :database_host     => 'node01.example.com',
          :zabbix_type       => 'server',
          :zabbix_version    => '2.4',
        }
      end

      it { should contain_exec('zabbix_server_create.sql').with_command("cd /usr/share/doc/zabbix-*-mysql-2.4*/create && if [ -f schema.sql.gz ]; then gunzip schema.sql.gz ; fi && mysql -h 'node01.example.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < schema.sql && touch /etc/zabbix/.schema.done") }
      it { should contain_exec('zabbix_server_images.sql').with_command("cd /usr/share/doc/zabbix-*-mysql-2.4*/create && if [ -f images.sql.gz ]; then gunzip images.sql.gz ; fi && mysql -h 'node01.example.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < images.sql && touch /etc/zabbix/.images.done") }
      it { should contain_exec('zabbix_server_data.sql').with_command("cd /usr/share/doc/zabbix-*-mysql-2.4*/create && if [ -f data.sql.gz ]; then gunzip data.sql.gz ; fi && mysql -h 'node01.example.com' -u 'zabbix-server' -p'zabbix-server' -D 'zabbix-server' < data.sql && touch /etc/zabbix/.data.done") }
    end

    describe "when zabbix_type is proxy" do
      let (:params) do
        {
          :database_name     => 'zabbix-proxy',
          :database_user     => 'zabbix-proxy',
          :database_password => 'zabbix-proxy',
          :database_host     => 'node01.example.com',
          :zabbix_type       => 'proxy',
          :zabbix_version    => '2.4',
        }
      end

      it { should contain_exec('zabbix_proxy_create.sql').with_command("cd /usr/share/doc/zabbix-*-mysql-2.4*/create && if [ -f schema.sql.gz ]; then gunzip schema.sql.gz ; fi && mysql -h 'node01.example.com' -u 'zabbix-proxy' -p'zabbix-proxy' -D 'zabbix-proxy' < schema.sql && touch /etc/zabbix/.schema.done") }
    end
  end
end
