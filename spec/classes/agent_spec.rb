require 'spec_helper'

describe 'zabbix::agent' do
  let(:node) { 'agent.example.com' }
  let(:params) { {:server => '192.168.1.1', :serveractive => '192.168.1.1', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }

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

  # Need the zabbix::repo?
  context "when declaring manage_repo is true" do
    let(:params) {{ :manage_repo => true }}
    it { should contain_class('zabbix::repo').with_zabbix_version('2.4') }
    it { should contain_package('zabbix-agent').with_require('Class[Zabbix::Repo]')}
  end

  context "when declaring manage_resources is true" do
    let(:params) {{ :manage_resources => true }}
    it { should contain_class('zabbix::resources::agent') }
  end

  # Make sure package will be installed, service running and ensure of directory.
  it { should contain_package('zabbix-agent').with_ensure('present') }
  it { should contain_package('zabbix-agent').with_name('zabbix-agent') }

  it { should contain_service('zabbix-agent').with_ensure('running') }
  it { should contain_service('zabbix-agent').with_name('zabbix-agent') }

  it { should contain_file('/etc/zabbix/zabbix_agentd.d').with_ensure('directory') }

  # Configuration file
  context 'with pidfile => /var/run/zabbix/zabbix_agentd.pid' do
      let(:params) { {:pidfile => '/var/run/zabbix/zabbix_agentd.pid', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^PidFile=/var/run/zabbix/zabbix_agentd.pid$}}
  end

  context 'with logfile => /var/run/zabbix/zabbix_agentd.pid' do
      let(:params) { {:logfile => '/var/log/zabbix/zabbix_agentd.log', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogFile=/var/log/zabbix/zabbix_agentd.log$}}
  end

  context 'with DebugLevel => 4' do
      let(:params) { {:debuglevel => '4', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^DebugLevel=4$}}
  end

  context 'with logfilesize => 4' do
      let(:params) { {:logfilesize => '4', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogFileSize=4$}}
  end

  context 'with EnableRemoteCommands => 1' do
      let(:params) { {:enableremotecommands => '1', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^EnableRemoteCommands=1$}}
  end

  context 'with LogRemoteCommands => 0' do
      let(:params) { {:logremotecommands => '0', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogRemoteCommands=0$}}
  end

  context 'with server => 192.168.1.1' do
      let(:params) { {:server => '192.168.1.1', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Server=192.168.1.1$}}
  end

  context 'with ListenPort => 10050' do
      let(:params) { {:listenport => '10050', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ListenPort=10050$}}
  end

  context 'with StartAgents => 3' do
      let(:params) { {:startagents => '3', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^StartAgents=3$}}
  end

  context 'with ServerActive => 192.168.1.1' do
      let(:params) { {:serveractive => '192.168.1.1', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ServerActive=192.168.1.1$}}
  end

  context 'with Hostname => 192.168.1.1' do
      let(:params) { {:hostname => '10050', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Hostname=10050$}}
  end

  context 'with HostnameItem => system.hostname' do
      let(:params) { {:hostnameitem => 'system.hostname', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^HostnameItem=system.hostname$}}
  end

  context 'with RefreshActiveChecks => 120' do
      let(:params) { {:refreshactivechecks => '120', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^RefreshActiveChecks=120$}}
  end
  
  context 'with BufferSend => 5' do
      let(:params) { {:buffersend => '5', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^BufferSend=5$}}
  end

  context 'with BufferSize => 100' do
      let(:params) { {:buffersize => '100', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^BufferSize=100$}}
  end

  context 'with Timeout => 30' do
      let(:params) { {:timeout => '30', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Timeout=30$}}
  end

  context 'with AllowRoot => 0' do
      let(:params) { {:allowroot => '0', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^AllowRoot=0$}}
  end

  context 'with Include => /etc/zabbix/zabbix_agentd.d' do
      let(:params) { {:include_dir => '/etc/zabbix/zabbix_agentd.d', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Include=/etc/zabbix/zabbix_agentd.d$}}
  end

  context 'with UnsafeUserParameters => 0' do
      let(:params) { {:unsafeuserparameters => '0', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^UnsafeUserParameters=0$}}
  end

  context 'with LoadModulePath => ${libdir}/modules' do
      let(:params) { {:loadmodulepath => '${libdir}/modules', :agent_configfile_path => '/etc/zabbix/zabbix_agentd.conf'} }
      it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LoadModulePath=\$\{libdir\}/modules$}}
  end

  # Firewall
  context "when declaring manage_firewall is true" do
    let(:params) {{ :manage_firewall => true }}
    it { should contain_firewall('150 zabbix-agent') }
  end
  
  context "when declaring manage_firewall is false" do
    let(:params) {{ :manage_firewall => false }}
    it { should_not contain_firewall('150 zabbix-agent') }
  end
  end
end
