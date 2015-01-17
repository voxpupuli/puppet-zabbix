require 'spec_helper'

describe 'zabbix::web' do
  # Set some facts / params.
  let(:node) { 'rspec.puppet.com' }
  let(:params) {{ :zabbix_url => 'zabbix.example.com' }}

  # Running an RedHat OS.
  context 'On a RedHat OS' do
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6.5',
        :architecture           => 'x86_64',
        :lsbdistid              => 'RedHat',
        :concat_basedir         => '/tmp'
      }
    end

    describe 'with database_type as postgresql' do
        let(:params) {{ :database_type => 'postgresql' }}
        it { should contain_package('zabbix-web-pgsql').with_name('zabbix-web-pgsql') }
        it { should contain_package('zabbix-web')}
    end

    describe 'with database_type as mysql' do
        let(:params) {{ :database_type => 'mysql' }}
        it { should contain_package('zabbix-web-mysql').with_name('zabbix-web-mysql') }
        it { should contain_package('zabbix-web')}
    end

    it { should contain_file('/etc/zabbix/web/zabbix.conf.php')}

    describe "when manage_resources is true" do
        let(:params) {{ :manage_resources => true }}
        it { should contain_class('zabbix::resources::web') }
        
        it { should contain_package('zabbixapi').that_requires('Class[ruby::dev]') }
        it { should contain_class('ruby::dev') }
    end
    
    describe "when manage_resources is false" do
        let(:params) {{ :manage_resources => false}}
        it { should_not contain_class('zabbix::resources::web') }
    end

    it { should contain_apache__vhost('zabbix.example.com').with_name('zabbix.example.com') }

    context 'with database_type => postgresql' do
      let(:params) { { :database_type => 'postgresql' } }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['TYPE'\]     = 'POSTGRESQL'/) }
    end

    context 'with database_host => localhost' do
      let(:params) { { :database_host => 'localhost' } }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['SERVER'\]   = 'localhost'/) }
    end

    context 'with database_name => zabbix-server' do
      let(:params) { { :database_name => 'zabbix-server' } }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['DATABASE'\] = 'zabbix-server'/) }
    end

    context 'with database_user => zabbix-server' do
      let(:params) { { :database_user => 'zabbix-server' } }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['USER'\]     = 'zabbix-server'/) }
    end

    context 'with database_password => zabbix-server' do
      let(:params) { { :database_password => 'zabbix-server' } }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['PASSWORD'\] = 'zabbix-server'/) }
    end

    context 'with zabbix_server => localhost' do
      let(:params) { { :zabbix_server => 'localhost' } }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$ZBX_SERVER      = 'localhost'/) }
    end

    context 'with zabbix_listenport => localhost' do
      let(:params) { { :zabbix_listenport => '10051' } }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$ZBX_SERVER_PORT = '10051'/) }
    end

    context 'with zabbix_server => localhost' do
      let(:params) { { :zabbix_server => 'localhost' } }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$ZBX_SERVER_NAME = 'localhost'/) }
    end

  end
end

describe 'zabbix::web' do
  # Set some facts / params.
  let(:node) { 'rspec.puppet.com' }
  let(:params) {{ :zabbix_url => 'zabbix.example.com' }}

  # Running an Debian OS.
  context 'On a Debian OS' do
    let :facts do
      {
        :osfamily               => 'debian',
        :operatingsystem        => 'debian',
        :operatingsystemrelease => '6.0',
        :architecture           => 'x86_64',
        :lsbdistid              => 'debian',
        :concat_basedir         => '/tmp'
      }
    end
  it { should contain_package('zabbix-frontend-php')}
  end

end
