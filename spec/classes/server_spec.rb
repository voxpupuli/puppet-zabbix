require 'spec_helper'

describe 'zabbix::server' do
  # Set some facts / params.
  let(:params) { { :zabbix_version => '2.4'} }
  let(:node) { 'rspec.puppet.com' }

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

    it { should contain_class('zabbix::repo') }
    it { should contain_service('zabbix-server').with_ensure('running') }

    describe 'with database_type as postgresql' do
        let(:params) {{ :database_type => 'postgresql', :server_configfile_path => '/etc/zabbix/zabbix_server.conf', :include_dir => '/etc/zabbix/zabbix_server.conf.d' }}
        it { should contain_package('zabbix-server-pgsql').with_ensure('present') }
        it { should contain_package('zabbix-server-pgsql').with_name('zabbix-server-pgsql') }
        it { should contain_file('/etc/zabbix/zabbix_server.conf').with_require('Package[zabbix-server-pgsql]') }
    end

    describe 'with database_type as mysql' do
        let(:params) {{ :database_type => 'mysql' }}
        it { should contain_package('zabbix-server-mysql').with_ensure('present') }
        it { should contain_package('zabbix-server-mysql').with_name('zabbix-server-mysql') }
        it { should contain_file('/etc/zabbix/zabbix_server.conf').with_require('Package[zabbix-server-mysql]') }
    end

    # Include directory should be available.
    it { should contain_file('/etc/zabbix/zabbix_server.conf.d').with_ensure('directory') }
    it { should contain_file('/etc/zabbix/zabbix_server.conf.d').with_require('File[/etc/zabbix/zabbix_server.conf]') }
   
    context 'with zabbix::database::postgresql class' do
      let(:params) {{ :database_type => 'postgresql', :database_user => 'zabbix-server', :database_password => 'zabbix-server', :database_host => 'localhost', :database_name => 'zabbix-server' }}
      it { should contain_class('zabbix::database::postgresql').with_zabbix_type('server')}
      it { should contain_class('zabbix::database::postgresql').with_zabbix_version('2.4')}
      it { should contain_class('zabbix::database::postgresql').with_database_name('zabbix-server')}
      it { should contain_class('zabbix::database::postgresql').with_database_user('zabbix-server')}
      it { should contain_class('zabbix::database::postgresql').with_database_password('zabbix-server')}
      it { should contain_class('zabbix::database::postgresql').with_database_host('localhost')}
    end

    context 'with zabbix::database::mysql class' do
      let(:params) {{ :database_type => 'mysql', :database_user => 'zabbix-server', :database_password => 'zabbix-server', :database_host => 'localhost', :database_name => 'zabbix-server' }}
      it { should contain_class('zabbix::database::mysql').with_zabbix_type('server')}
      it { should contain_class('zabbix::database::mysql').with_zabbix_version('2.4')}
      it { should contain_class('zabbix::database::mysql').with_database_name('zabbix-server')}
      it { should contain_class('zabbix::database::mysql').with_database_user('zabbix-server')}
      it { should contain_class('zabbix::database::mysql').with_database_password('zabbix-server')}
      it { should contain_class('zabbix::database::mysql').with_database_host('localhost')}
    end

    # So if manage_firewall is set to true, it should install
    # the firewall rule.
    context "when declaring manage_firewall is true" do
      let(:params) {{ :manage_firewall => true }}
      it { should contain_firewall('151 zabbix-server') }
    end
  
    context "when declaring manage_firewall is false" do
      let(:params) {{ :manage_firewall => false }}
      it { should_not contain_firewall('151 zabbix-server') }
    end 

    context 'with nodeid => 0' do
      let(:params) { { :nodeid => '0', :zabbix_version => '2.2'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeID=0$}}
    end

    context 'with nodeid => 0' do
      let(:params) { { :nodeid => '0', :zabbix_version => '2.4'} }
      it { should_not contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeID=0$}}
    end

    context 'with listenport => 10051' do
      let(:params) { { :listenport => '10051'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ListenPort=10051$}}
    end

    context 'with sourceip => 10051' do
      let(:params) { { :sourceip => '192.168.1.1'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^SourceIP=192.168.1.1}}
    end

    context 'with logfile => /var/log/zabbix/zabbix_server.log' do
      let(:params) { { :logfile => '/var/log/zabbix/zabbix_server.log'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LogFile=/var/log/zabbix/zabbix_server.log}}
    end

    context 'with logfilesize => 10' do
      let(:params) { { :logfilesize => '10'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LogFileSize=10}}
    end

    context 'with debuglevel => 3' do
      let(:params) { { :debuglevel => '3'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DebugLevel=3}}
    end

    context 'with pidfile => /var/run/zabbix/zabbix_server.pid' do
      let(:params) { { :pidfile => '/var/run/zabbix/zabbix_server.pid'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^PidFile=/var/run/zabbix/zabbix_server.pid}}
    end

    context 'with database_host => localhost' do
      let(:params) { { :database_host => 'localhost'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBHost=localhost}}
    end

    context 'with database_name => zabbix-server' do
      let(:params) { { :database_name => 'zabbix-server'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBName=zabbix-server}}
    end

    context 'with database_schema => zabbix-server' do
      let(:params) { { :database_schema => 'zabbix-server'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBSchema=zabbix-server}}
    end

    context 'with database_user => zabbix-server' do
      let(:params) { { :database_user => 'zabbix-server'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBUser=zabbix-server}}
    end

    context 'with database_password => zabbix-server' do
      let(:params) { { :database_password => 'zabbix-server'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBPassword=zabbix-server}}
    end

    context 'with database_socket => /tmp/socket.db' do
      let(:params) { { :database_socket => '/tmp/socket.db'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBSocket=/tmp/socket.db}}
    end

    context 'with database_port => 3306' do
      let(:params) { { :database_port => '3306'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBPort=3306}}
    end

    context 'with startpollers => 12' do
      let(:params) { { :startpollers => '12'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartPollers=12}}
    end

    context 'with startipmipollers => 12' do
      let(:params) { { :startipmipollers => '12'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartIPMIPollers=12}}
    end

    context 'with startpollersunreachable => 1' do
      let(:params) { { :startpollersunreachable => '1'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartPollersUnreachable=1}}
    end

    context 'with starttrappers => 5' do
      let(:params) { { :starttrappers => '5'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartTrappers=5}}
    end

    context 'with startpingers => 1' do
      let(:params) { { :startpingers => '1'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartPingers=1}}
    end

    context 'with startdiscoverers => 1' do
      let(:params) { { :startdiscoverers => '1'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartDiscoverers=1}}
    end

    context 'with starthttppollers => 1' do
      let(:params) { { :starthttppollers => '1'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartHTTPPollers=1}}
    end

    context 'with starttimers => 1' do
      let(:params) { { :starttimers => '1', :zabbix_version => '2.2'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartTimers=1}}
    end

    context 'with javagateway => 192.168.2.2' do
      let(:params) { { :javagateway => '192.168.2.2'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^JavaGateway=192.168.2.2}}
    end

    context 'with javagatewayport => 10052' do
      let(:params) { { :javagateway => '192.168.2.2', :javagatewayport => '10052'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^JavaGatewayPort=10052}}
    end

    context 'with startvmwarecollectors => 5' do
      let(:params) { { :startvmwarecollectors => '5', :zabbix_version => '2.2'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartVMwareCollectors=5}}
    end

    context 'with vmwarefrequency => 60' do
      let(:params) { { :vmwarefrequency => '60', :zabbix_version => '2.2'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^VMwareFrequency=60}}
    end

    context 'with vmwarecachesize => 8M' do
      let(:params) { { :vmwarecachesize => '8M', :zabbix_version => '2.2'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^VMwareCacheSize=8M}}
    end

    context 'with snmptrapperfile => /tmp/zabbix_traps.tmp' do
      let(:params) { { :snmptrapperfile => '/tmp/zabbix_traps.tmp'} }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^SNMPTrapperFile=/tmp/zabbix_traps.tmp}}
    end

    context 'with startsnmptrapper => 1' do
      let(:params) { { :startsnmptrapper => '1' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartSNMPTrapper=1}}
    end

    context 'with listenip => 192.168.1.1' do
      let(:params) { { :listenip => '192.168.1.1' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ListenIP=192.168.1.1}}
    end

    context 'with housekeepingfrequency => 1' do
      let(:params) { { :housekeepingfrequency => '1' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^HousekeepingFrequency=1}}
    end

    context 'with maxhousekeeperdelete => 500' do
      let(:params) { { :maxhousekeeperdelete => '500' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^MaxHousekeeperDelete=500}}
    end

    context 'with senderfrequency => 30' do
      let(:params) { { :senderfrequency => '30' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^SenderFrequency=30}}
    end

    context 'with cachesize => 8M' do
      let(:params) { { :cachesize => '8M' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^CacheSize=8M}}
    end

    context 'with cacheupdatefrequency => 30' do
      let(:params) { { :cacheupdatefrequency => '30' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^CacheUpdateFrequency=30}}
    end

    context 'with startdbsyncers => 4' do
      let(:params) { { :startdbsyncers => '4' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartDBSyncers=4}}
    end

    context 'with historycachesize => 4M' do
      let(:params) { { :historycachesize => '4M' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^HistoryCacheSize=4M}}
    end

    context 'with trendcachesize => 4M' do
      let(:params) { { :trendcachesize => '4M' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TrendCacheSize=4M}}
    end

    context 'with historytextcachesize => 4M' do
      let(:params) { { :historytextcachesize => '4M' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^HistoryTextCacheSize=4M}}
    end

    context 'with valuecachesize => 4M' do
      let(:params) { { :valuecachesize => '4M', :zabbix_version => '2.2' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ValueCacheSize=4M}}
    end

    context 'with nodenoevents => 0' do
      let(:params) { { :nodenoevents => '0', :zabbix_version => '2.2' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeNoEvents=0}}
    end

    context 'with nodenoevents => 0' do
      let(:params) { { :nodenoevents => '0', :zabbix_version => '2.4' } }
      it { should_not contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeNoEvents=0}}
    end

    context 'with nodenohistory => 0' do
      let(:params) { { :nodenohistory => '0',:zabbix_version => '2.2' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeNoHistory=0}}
    end

    context 'with nodenohistory => 0' do
      let(:params) { { :nodenohistory => '0', :zabbix_version => '2.4' } }
      it { should_not contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeNoHistory=0}}
    end

    context 'with timeout => 3' do
      let(:params) { { :timeout => '3' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^Timeout=3}}
    end

    context 'with trappertimeout => 30' do
      let(:params) { { :trappertimeout => '30' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TrapperTimeout=30}}
    end

    context 'with unreachableperiod => 30' do
      let(:params) { { :unreachableperiod => '30' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^UnreachablePeriod=30}}
    end

    context 'with unavailabledelay => 30' do
      let(:params) { { :unavailabledelay => '30' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^UnavailableDelay=30}}
    end

    context 'with unreachabledelay => 30' do
      let(:params) { { :unreachabledelay => '30' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^UnreachableDelay=30}}
    end

    context 'with alertscriptspath => ${datadir}/zabbix/alertscripts' do
      let(:params) { { :alertscriptspath => '${datadir}/zabbix/alertscripts' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^AlertScriptsPath=\$\{datadir\}/zabbix/alertscripts}}
    end

    context 'with externalscripts => /usr/lib/zabbix/externalscripts' do
      let(:params) { { :externalscripts => '/usr/lib/zabbix/externalscripts0' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ExternalScripts=/usr/lib/zabbix/externalscripts}}
    end

    context 'with fpinglocation => /usr/sbin/fping' do
      let(:params) { { :fpinglocation => '/usr/sbin/fping' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^FpingLocation=/usr/sbin/fping}}
    end

    context 'with fping6location => /usr/sbin/fping6' do
      let(:params) { { :fping6location => '/usr/sbin/fping6' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^Fping6Location=/usr/sbin/fping6}}
    end

    context 'with sshkeylocation => /home/zabbix' do
      let(:params) { { :sshkeylocation => '/home/zabbix' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^SSHKeyLocation=/home/zabbix}}
    end

    context 'with logslowqueries => 0' do
      let(:params) { { :logslowqueries => '0' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LogSlowQueries=0}}
    end

    context 'with tmpdir => /tmp' do
      let(:params) { { :tmpdir => '/tmp' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TmpDir=/tmp}}
    end

    context 'with startproxypollers => 1' do
      let(:params) { { :startproxypollers => '1' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartProxyPollers=1}}
    end

    context 'with proxyconfigfrequency => 3600' do
      let(:params) { { :proxyconfigfrequency => '3600' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ProxyConfigFrequency=3600}}
    end

    context 'with proxydatafrequency => 1' do
      let(:params) { { :proxydatafrequency => '1' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ProxyDataFrequency=1}}
    end

    context 'with allowroot => 1' do
      let(:params) { { :allowroot => '1' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^AllowRoot=1}}
    end

    context 'with include_dir => /etc/zabbix/zabbix_server.conf.d' do
      let(:params) { { :include_dir => '/etc/zabbix/zabbix_server.conf.d' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^Include=/etc/zabbix/zabbix_server.conf.d}}
    end

    context 'with loadmodulepath => ${libdir}/modules' do
      let(:params) { { :loadmodulepath => '${libdir}/modules' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LoadModulePath=\$\{libdir\}/modules}}
    end

    context 'with loadmodule => pizza' do
      let(:params) { { :loadmodule => 'pizza' } }
      it { should contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LoadModule = pizza}}
    end

  end
end
