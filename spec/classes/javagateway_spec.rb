require 'spec_helper'

describe 'zabbix::javagateway' do
  # Set some facts / params.
  let(:node) { 'rspec.puppet.com' }
  let(:params) { { :listenip => '192.168.1.1' } }

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

    context "when declaring manage_repo is true" do
      let(:params) {{ :manage_repo => true }}
      it { should contain_class('zabbix::repo').with_zabbix_version('2.4') }
      it { should contain_package('zabbix-java-gateway').with_require('Class[Zabbix::Repo]') }
    end

    context "Do some stuff" do
      it { should contain_service('zabbix-java-gateway').with_ensure('running') }
      it { should contain_service('zabbix-java-gateway').with_require(['Package[zabbix-java-gateway]','File[/etc/zabbix/zabbix_java_gateway.conf]']) }
      it { should contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_require('Package[zabbix-java-gateway]') }
    end

    context 'when declaring manage_repo is false' do
      let(:params) {{ :manage_repo => false }}
      it { should_not contain_class('Zabbix::Repo') }
    end # END context 'when declaring manage_repo is false'

    context "when declaring manage_firewall is true" do
      let(:params) {{ :manage_firewall => true }}
      it { should contain_firewall('152 zabbix-javagateway') }
    end
    context "when declaring manage_firewall is false" do
      let(:params) {{ :manage_firewall => false }}
      it { should_not contain_firewall('152 zabbix-javagateway') }
    end
  end # END context 'On a RedHat OS'

  # Running an Debian OS.
  context 'On a Debian OS' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian',
        :concat_basedir         => '/tmp'
      }
    end

    context "when declaring manage_repo is true" do
      let(:params) {{ :manage_repo => true }}
      it { should contain_class('zabbix::repo').with_zabbix_version('2.4') }
      it { should contain_package('zabbix-java-gateway').with_require('Class[Zabbix::Repo]') }
    end

    context "Do some stuff" do
      it { should contain_service('zabbix-java-gateway').with_ensure('running') }
      it { should contain_service('zabbix-java-gateway').with_require(['Package[zabbix-java-gateway]','File[/etc/zabbix/zabbix_java_gateway.conf]']) }
      it { should contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_require('Package[zabbix-java-gateway]') }
    end

    context 'when declaring manage_repo is false' do
      let(:params) {{ :manage_repo => false }}
      it { should_not contain_class('Zabbix::Repo') }
    end # END context 'when declaring manage_repo is false'

    context "when declaring manage_firewall is true" do
      let(:params) {{ :manage_firewall => true }}
      it { should contain_firewall('152 zabbix-javagateway') }
    end
    context "when declaring manage_firewall is false" do
      let(:params) {{ :manage_firewall => false }}
      it { should_not contain_firewall('152 zabbix-javagateway') }
    end
  end # END context 'On a Debian OS'

  # Running an Ubuntu OS.
  context 'On a Ubuntu OS' do
    let :facts do
      {
        :osfamily               => 'Ubuntu',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Ubuntu',
        :concat_basedir         => '/tmp'
      }
    end

    context "when declaring manage_repo is true" do
      let(:params) {{ :manage_repo => true }}
      it { should contain_class('zabbix::repo').with_zabbix_version('2.4') }
      it { should contain_package('zabbix-java-gateway').with_require('Class[Zabbix::Repo]') }
    end

    context "Do some stuff" do
      it { should contain_service('zabbix-java-gateway').with_ensure('running') }
      it { should contain_service('zabbix-java-gateway').with_require(['Package[zabbix-java-gateway]','File[/etc/zabbix/zabbix_java_gateway.conf]']) }
      it { should contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_require('Package[zabbix-java-gateway]') }
    end

    context 'when declaring manage_repo is false' do
      let(:params) {{ :manage_repo => false }}
      it { should_not contain_class('Zabbix::Repo') }
    end # END context 'when declaring manage_repo is false'

    context "when declaring manage_firewall is true" do
      let(:params) {{ :manage_firewall => true }}
      it { should contain_firewall('152 zabbix-javagateway') }
    end
    context "when declaring manage_firewall is false" do
      let(:params) {{ :manage_firewall => false }}
      it { should_not contain_firewall('152 zabbix-javagateway') }
    end
  end

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

    context 'with listenip => 192.168.1.1' do
      let(:params) { {:listenip => '192.168.1.1'} }
      it { should contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^LISTEN_IP="192.168.1.1"$}}
    end

    context 'with listenport => 10052' do
      let(:params) { {:listenport => '10052'} }
      it { should contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^LISTEN_PORT=10052$}}
    end

    context 'with pidfile => /var/run/zabbix/zabbix_java.pid' do
      let(:params) { {:pidfile => '/var/run/zabbix/zabbix_java.pid'} }
      it { should contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^PID_FILE="/var/run/zabbix/zabbix_java.pid"$}}
    end

    context 'with startpollers => 1' do
      let(:params) { {:startpollers => '1'} }
      it { should contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^START_POLLERS=1$}}
    end
  end # END context 'On a RedHat OS' do
end
