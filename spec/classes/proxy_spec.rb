require 'spec_helper'

describe 'zabbix::proxy' do
  # Set some facts / params.
  let(:params) { {:zabbix_server_host => '192.168.1.1', :zabbix_version => '2.4'} }
  let(:node) { 'rspec.puppet.com' }

  context 'On a RedHat OS' do
    # Set some facts first.
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

    describe "when manage_repo is true" do
        let(:params) {{ :manage_repo => true }}
        it { should contain_class('zabbix::repo').with_zabbix_version('2.4') }
        it { should contain_package('zabbix-proxy-pgsql').with_require('Class[Zabbix::Repo]') }
    end

    describe "when databaste_type is postgresql" do
        let(:params) {{ :database_type => 'postgresql' }}
        it { should contain_package('zabbix-proxy-pgsql').with_ensure('present') }
        it { should contain_package('zabbix-proxy-pgsql').with_ensure('present') }
        it { should contain_package('zabbix-proxy-pgsql').with_name('zabbix-proxy-pgsql') }
        it { should contain_service('zabbix-proxy').with_require(['Package[zabbix-proxy-pgsql]','File[/etc/zabbix/zabbix_proxy.conf.d]','File[/etc/zabbix/zabbix_proxy.conf]']) }
        it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_require('Package[zabbix-proxy-pgsql]') }
    end

    describe "when databaste_type is mysql" do
        let(:params) {{ :database_type => 'mysql' }}
        it { should contain_package('zabbix-proxy-mysql').with_ensure('present') }
        it { should contain_package('zabbix-proxy-mysql').with_ensure('present') }
        it { should contain_package('zabbix-proxy-mysql').with_name('zabbix-proxy-mysql') }
        it { should contain_service('zabbix-proxy').with_require(['Package[zabbix-proxy-mysql]','File[/etc/zabbix/zabbix_proxy.conf.d]','File[/etc/zabbix/zabbix_proxy.conf]']) }
        it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_require('Package[zabbix-proxy-mysql]') }
    end

    describe "when databaste_type is mysql" do
        let(:params) {{ :manage_resources => true }}
        it { should contain_class('zabbix::resources::proxy') }
    end

    describe "whem manage_repo is true" do
        let(:params) {{ :manage_repo => true }}
        it { should contain_class('Zabbix::Repo') }
    end

    it { should contain_file('/etc/zabbix/zabbix_proxy.conf.d').with_ensure('directory') }
    it { should contain_file('/etc/zabbix/zabbix_proxy.conf.d').with_require('File[/etc/zabbix/zabbix_proxy.conf]') }
  
  
    context 'with zabbix::database::postgresql class' do
      let(:params) {{ :database_type => 'postgresql', :manage_database => true }}
      it { should contain_class('zabbix::database::postgresql').with_zabbix_type('proxy')}
      it { should contain_class('zabbix::database::postgresql').with_zabbix_version('2.4')}
      it { should contain_class('zabbix::database::postgresql').with_database_name('zabbix_proxy')}
      it { should contain_class('zabbix::database::postgresql').with_database_user('zabbix-proxy')}
      it { should contain_class('zabbix::database::postgresql').with_database_password('zabbix-proxy')}
      it { should contain_class('zabbix::database::postgresql').with_database_host('localhost')}
    end

  
    context 'with zabbix::database::mysql class' do
      let(:params) {{ :database_type => 'mysql', :manage_database => true }}
      it { should contain_class('zabbix::database::mysql').with_zabbix_type('proxy')}
      it { should contain_class('zabbix::database::mysql').with_zabbix_version('2.4')}
      it { should contain_class('zabbix::database::mysql').with_database_name('zabbix_proxy')}
      it { should contain_class('zabbix::database::mysql').with_database_user('zabbix-proxy')}
      it { should contain_class('zabbix::database::mysql').with_database_password('zabbix-proxy')}
      it { should contain_class('zabbix::database::mysql').with_database_host('localhost')}
    end

    context 'when manage_database is true' do
      let(:params) {{ :manage_database => true }}
      it { should contain_class('zabbix::database').with_zabbix_type('proxy')}
      it { should contain_class('zabbix::database').with_database_type('postgresql')}
      it { should contain_class('zabbix::database').with_database_name('zabbix_proxy')}
      it { should contain_class('zabbix::database').with_database_user('zabbix-proxy')}
      it { should contain_class('zabbix::database').with_database_password('zabbix-proxy')}
      it { should contain_class('zabbix::database').with_database_host('localhost')}
      it { should contain_class('zabbix::database').with_zabbix_proxy('localhost')}
      it { should contain_class('zabbix::database').with_zabbix_proxy_ip('127.0.0.1')}
    end

    context "when declaring manage_firewall is true" do
      let(:params) {{ :manage_firewall => true }}
      it { should contain_firewall('151 zabbix-proxy') }
    end

    context "when declaring manage_firewall is false" do
      let(:params) {{ :manage_firewall => false }}
      it { should_not contain_firewall('151 zabbix-proxy') }
    end


  # Make sure we have set some vars in zabbix_proxy.conf file. This is configuration file is the same on all
  # operating systems. So we aren't testing this for all opeating systems, just this one.

    context 'with mode => 0' do
      let(:params) { {:mode => '0'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ProxyMode=0$}}
    end

    context 'with zabbix_server_host => 192.168.1.1' do
      let(:params) { {:zabbix_server_host => '192.168.1.1'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Server=192.168.1.1$}}
    end

    context 'with zabbix_server_port => 10051' do
      let(:params) { {:zabbix_server_port => '10051'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ServerPort=10051$}}
    end

    context 'with zabbix_server_port => 10051' do
      let(:params) { {:zabbix_server_port => '10051'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ServerPort=10051$}}
    end

    context 'with Hostname => rspec.puppet.com' do
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Hostname=rspec.puppet.com$}}
    end

    context 'with listenport => 10051' do
      let(:params) { {:listenport => '10051'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ListenPort=10051$}}
    end 

    context 'with logfile => /var/log/zabbix/proxy_server.log' do
      let(:params) { {:logfile => '/var/log/zabbix/proxy_server.log'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LogFile=/var/log/zabbix/proxy_server.log$}}
    end 

    context 'with logfilesize => 15' do
      let(:params) { {:logfilesize => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LogFileSize=15$}}
    end   

    context 'with debuglevel => 4' do
      let(:params) { {:debuglevel => '4'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DebugLevel=4$}}
    end   

    context 'with pidfile => /var/run/zabbix/proxy_server.pid' do
      let(:params) { {:pidfile => '/var/run/zabbix/proxy_server.pid'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^PidFile=/var/run/zabbix/proxy_server.pid$}}
    end   

    context 'with database_host => localhost' do
      let(:params) { {:database_host => 'localhost'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBHost=localhost$}}
    end   

    context 'with database_name => zabbix-proxy' do
      let(:params) { {:database_name => 'zabbix-proxy'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBName=zabbix-proxy$}}
    end   

    context 'with database_schema => zabbix-proxy' do
      let(:params) { {:database_schema => 'zabbix-proxy'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBSchema=zabbix-proxy$}}
    end   

    context 'with database_user => zabbix-proxy' do
      let(:params) { {:database_user => 'zabbix-proxy'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBUser=zabbix-proxy$}}
    end   

    context 'with database_password => zabbix-proxy' do
      let(:params) { {:database_password => 'zabbix-proxy'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DBPassword=zabbix-proxy$}}
    end   

    context 'with localbuffer => 0' do
      let(:params) { {:localbuffer => '0'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ProxyLocalBuffer=0$}}
    end   

    context 'with offlinebuffer => 1' do
      let(:params) { {:offlinebuffer => '1'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ProxyOfflineBuffer=1$}}
    end   

    context 'with heartbeatfrequency => 60' do
      let(:params) { {:heartbeatfrequency => '60'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^HeartbeatFrequency=60$}}
    end   

    context 'with configfrequency => 3600' do
      let(:params) { {:configfrequency => '3600'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ConfigFrequency=3600$}}
    end   

    context 'with datasenderfrequency => 1' do
      let(:params) { {:datasenderfrequency => '1'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^DataSenderFrequency=1$}}
    end   

    context 'with startpollers => 15' do
      let(:params) { {:startpollers => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartPollers=15$}}
    end   

    context 'with startipmipollers => 15' do
      let(:params) { {:startipmipollers => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartIPMIPollers=15$}}
    end   

    context 'with startpollersunreachable => 15' do
      let(:params) { {:startpollersunreachable => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartPollersUnreachable=15$}}
    end   

    context 'with starttrappers => 15' do
      let(:params) { {:starttrappers => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartTrappers=15$}}
    end   

    context 'with startpingers => 15' do
      let(:params) { {:startpingers => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartPingers=15$}}
    end   

    context 'with startdiscoverers => 15' do
      let(:params) { {:startdiscoverers => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartDiscoverers=15$}}
    end   

    context 'with starthttppollers => 15' do
      let(:params) { {:starthttppollers => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartHTTPPollers=15$}}
    end   

    context 'with javagateway => 192.168.1.2' do
      let(:params) { {:javagateway => '192.168.1.2'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^JavaGateway=192.168.1.2$}}
    end   

    context 'with javagatewayport => 10051' do
      let(:params) { {:javagateway => '192.168.1.2', :javagatewayport => '10051'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^JavaGatewayPort=10051$}}
    end   

    context 'with startjavapollers => 5' do
      let(:params) { {:javagateway => '192.168.1.2', :startjavapollers => '5'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartJavaPollers=5$}}
    end   

    context 'with startvmwarecollectors => 0' do
      let(:params) { {:startvmwarecollectors => '0'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartVMwareCollectors=0$}}
    end   

    context 'with vmwarefrequency => 60' do
      let(:params) { {:vmwarefrequency => '60'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^VMwareFrequency=60$}}
    end   

    context 'with vmwarecachesize => 8' do
      let(:params) { {:vmwarecachesize => '8'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^VMwareCacheSize=8M$}}
    end 
    
    context 'with snmptrapperfile => 60' do
      let(:params) { {:snmptrapperfile => '/tmp/zabbix_traps.tmp'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^SNMPTrapperFile=/tmp/zabbix_traps.tmp$}}
    end 
    
    context 'with snmptrapper => 0' do
      let(:params) { {:snmptrapper => '0'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartSNMPTrapper=0$}}
    end 

    context 'with listenip => 192.168.1.1' do
      let(:params) { {:listenip => '192.168.1.1'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ListenIP=192.168.1.1$}}
    end 
        
    context 'with housekeepingfrequency => 1' do
      let(:params) { {:housekeepingfrequency => '1'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^HousekeepingFrequency=1$}}
    end 
    
    context 'with cachesize => 8' do
      let(:params) { {:cachesize => '8'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^CacheSize=8M$}}
    end 
    
    context 'with startdbsyncers => 4' do
      let(:params) { {:startdbsyncers => '4'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^StartDBSyncers=4$}}
    end 

    context 'with historycachesize => 16' do
      let(:params) { {:historycachesize => '16'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^HistoryCacheSize=16M$}}
    end   
  
    context 'with historytextcachesize => 8' do
      let(:params) { {:historytextcachesize => '8'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^HistoryTextCacheSize=8M$}}
    end 
    
    context 'with timeout => 20' do
      let(:params) { {:timeout => '20'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Timeout=20$}}
    end 

    context 'with trappertimeout => 16' do
      let(:params) { {:trappertimeout => '16'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^TrapperTimeout=16$}}
    end   
  
    context 'with unreachableperiod => 45' do
      let(:params) { {:unreachableperiod => '45'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^UnreachablePeriod=45$}}
    end 

    context 'with unavaliabledelay => 60' do
      let(:params) { {:unavaliabledelay => '60'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^UnavailableDelay=60$}}
    end    
  
    context 'with unreachabedelay => 15' do
      let(:params) { {:unreachabedelay => '15'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^UnreachableDelay=15$}}
    end 

    context 'with externalscripts => 60' do
      let(:params) { {:externalscripts => '/usr/lib/zabbix/externalscripts'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^ExternalScripts=/usr/lib/zabbix/externalscripts$}}
    end  
  
    context 'with fpinglocation => 60' do
      let(:params) { {:fpinglocation => '60'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^FpingLocation=60$}}
    end    
  
    context 'with unreachabedelay => /usr/sbin/fping' do
      let(:params) { {:unreachabedelay => '/usr/sbin/fping'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^UnreachableDelay=/usr/sbin/fping$}}
    end 

    context 'with fping6location => /usr/sbin/fping6' do
      let(:params) { {:fping6location => '/usr/sbin/fping6'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Fping6Location=/usr/sbin/fping6$}}
    end  

    context 'with sshkeylocation => /home/zabbix/.ssh/' do
      let(:params) { {:sshkeylocation => '/home/zabbix/.ssh/'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^SSHKeyLocation=/home/zabbix/.ssh/$}}
    end   

    context 'with loglowqueries => 0' do
      let(:params) { {:loglowqueries => '0'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LogSlowQueries=0$}}
    end 

    context 'with tmpdir => /tmp' do
      let(:params) { {:tmpdir => '/tmp'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^TmpDir=/tmp$}}
    end  

    context 'with allowroot => 0' do
      let(:params) { {:allowroot => '0',:zabbix_version => '2.2'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^AllowRoot=0$}}
    end  

    context 'with include_dir => /etc/zabbix/zabbix_proxy.conf.d' do
      let(:params) { {:include_dir => '/etc/zabbix/zabbix_proxy.conf.d'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^Include=/etc/zabbix/zabbix_proxy.conf.d$}}
    end
    
    context 'with loadmodulepath => ${libdir}/modules' do
      let(:params) { {:loadmodulepath => '${libdir}/modules'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LoadModulePath=\$\{libdir\}/modules$}}
    end  

    context 'with loadmodule => pizza' do
      let(:params) { {:loadmodule => 'pizza'} }
      it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content %r{^LoadModule=pizza$}}
    end  
  end # END context 'zabbix_proxy.conf configuration'

end

