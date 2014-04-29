require 'spec_helper'

describe 'zabbix::agent' do
  # Set some facts / params.
  let(:facts) {{:operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
  let(:node) { 'agent.example.com' }
  let(:params) { {:server => '192.168.1.1', :serveractive => '192.168.1.1'} }

  context "when declaring manage_repo is true" do
    let(:params) {{ :manage_repo => true }}
    describe 'with repo' do
      # Make sure we have the zabbix::repo 
      it { should contain_class('zabbix::repo').with({
          'zabbix_version' => '2.2',
      })}
      # Make sure we have 'required' the zabbix::repo module for the package.
      it {should contain_package('zabbix-agent').with_require('Class[Zabbix::Repo]')}
  end

  context "when declaring manage_repo is false" do
    let(:params) {{ :manage_repo => false }}
    describe 'without repo' do
        it { should_not contain_class('Zabbix::Repo') }
    end
  end

  # Make sure package will be installed.
  it {should contain_package('zabbix-agent').with({
    :ensure => :present,
    :name   => 'zabbix-agent'
  })}

  # We need an zabbix-agent service.
  it { should contain_service('zabbix-agent').with(
    'name'       => 'zabbix-agent',
    'ensure'     => 'running',
    'enable'     => 'true',
    'hasstatus'  => 'true',
    'hasrestart' => 'true',
    'require'    => 'Package[zabbix-agent]'
  )}

  # Include directory should be available.
  it { should contain_file('/etc/zabbix/zabbix_agentd.d/').with(
    'ensure'  => 'directory',
    'owner'   => 'zabbix',
    'group'   => 'zabbix',
    'recurse' => 'true',
    'purge'   => 'true'
  )}

  # Make sure the confifuration file is present.
  it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with(
    'ensure'  => 'present',
    'owner'   => 'zabbix',
    'group'   => 'zabbix',
    'mode'    => '0644',
    'notify'  => 'Service[zabbix-agent]',
    'require' => 'Package[zabbix-agent]'
  )}

  # Make sure we have set some vars in zabbix_agentd.conf file. 
  context 'with pidfile => /var/run/zabbix/zabbix_agentd.pid' do
    let(:params) { {:pidfile => '/var/run/zabbix/zabbix_agentd.pid'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^PidFile=/var/run/zabbix/zabbix_agentd.pid$}}
  end

  context 'with logfile => /var/run/zabbix/zabbix_agentd.pid' do
    let(:params) { {:logfile => '/var/log/zabbix/zabbix_agentd.log'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogFile=/var/log/zabbix/zabbix_agentd.log$}}
  end

  context 'with DebugLevel => 4' do
    let(:params) { {:debuglevel => '4'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^DebugLevel=4$}}
  end

  context 'with logfilesize => 4' do
    let(:params) { {:logfilesize => '4'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogFileSize=4$}}
    end
  end

  context 'with EnableRemoteCommands => 1' do
    let(:params) { {:enableremotecommands => '1'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^EnableRemoteCommands=1$}}
  end

  context 'with LogRemoteCommands => 0' do
    let(:params) { {:logremotecommands => '0'} }
    it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogRemoteCommands=0$}}
  end

  context 'with server => 192.168.1.1' do
    let(:params) { {:server => '192.168.1.1'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Server=192.168.1.1$}}
  end

  context 'with ListenPort => 10050' do
    let(:params) { {:listenport => '10050'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ListenPort=10050$}}
  end

  context 'with listenip => 192.168.1.1' do
    let(:params) { {:listenip => '192.168.1.1'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ListenIP=192.168.1.1$}}
  end
  
  context 'with StartAgents => 3' do
    let(:params) { {:startagents => '3'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^StartAgents=3$}}
  end

  context 'with ServerActive => 192.168.1.1' do
    let(:params) { {:serveractive => '192.168.1.1'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ServerActive=192.168.1.1$}}
  end

  context 'with Hostname => 192.168.1.1' do
    let(:params) { {:hostname => '10050'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Hostname=10050$}}
  end

  context 'with HostnameItem => system.hostname' do
    let(:params) { {:hostnameitem => 'system.hostname'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^HostnameItem=system.hostname$}}
  end

  context 'with RefreshActiveChecks => 120' do
    let(:params) { {:refreshactivechecks => '120'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^RefreshActiveChecks=120$}}
  end
  
  context 'with BufferSend => 5' do
    let(:params) { {:buffersend => '5'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^BufferSend=5$}}
  end

  context 'with BufferSize => 100' do
    let(:params) { {:buffersize => '100'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^BufferSize=100$}}
  end

  context 'with Timeout => 30' do
    let(:params) { {:timeout => '30'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Timeout=30$}}
  end

  context 'with AllowRoot => 0' do
    let(:params) { {:allowroot => '0'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^AllowRoot=0$}}
  end

  context 'with Include => /etc/zabbix/zabbix_agentd.d/' do
    let(:params) { {:include_dir => '/etc/zabbix/zabbix_agentd.d/'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Include=/etc/zabbix/zabbix_agentd.d/$}}
  end

  context 'with UnsafeUserParameters => 0' do
    let(:params) { {:unsafeuserparameters => '0'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^UnsafeUserParameters=0$}}
  end

  context 'with LoadModulePath => ${libdir}/modules' do
    let(:params) { {:loadmodulepath => '${libdir}/modules'} }
    it {should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LoadModulePath=\$\{libdir\}/modules$}}
  end

  # So if manage_firewall is set to true, it should install
  # the firewall rule.
  context "when declaring manage_firewall is true" do
    let(:params) {{ :manage_firewall => true }}
    describe 'with firewall' do
      it { should contain_firewall('150 zabbix-agent') }
    end
  end
  
  # If not, we don't want an firewall rule.
  context "when declaring manage_firewall is false" do
    let(:params) {{ :manage_firewall => false }}
    describe 'without firewall' do
      it { should_not contain_firewall('150 zabbix-agent') }
    end
  end
# END of file
end
