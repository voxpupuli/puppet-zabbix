require 'spec_helper'

describe 'zabbix::server' do
  let :node do
    'rspec.puppet.com'
  end

  on_supported_os.each do |os, facts|
    next if facts[:osfamily] == 'Archlinux' # zabbix server is currently not supported on archlinux
    context "on #{os} " do
      let :facts do
        facts
      end

      describe 'with default settings' do
        it { is_expected.to contain_class('zabbix::repo') }
        it { is_expected.to contain_service('zabbix-server').with_ensure('running') }
        it { is_expected.to contain_zabbix__startup('zabbix-server') }
      end

      if facts[:osfamily] == 'RedHat'
        describe 'with enabled selinux' do
          let :facts do
            super().merge(selinux: true)
          end

          it { is_expected.to contain_selboolean('zabbix_can_network').with('value' => 'on', 'persistent' => true) }
        end
      end

      describe 'with disabled selinux' do
        let :facts do
          super().merge(selinux: false)
        end

        it { is_expected.not_to contain_selboolean('zabbix_can_network').with('value' => 'on', 'persistent' => true) }
      end

      describe 'with database_type as postgresql' do
        let :params do
          {
            database_type: 'postgresql',
            server_configfile_path: '/etc/zabbix/zabbix_server.conf',
            include_dir: '/etc/zabbix/zabbix_server.conf.d'
          }
        end

        it { is_expected.to contain_package('zabbix-server-pgsql').with_ensure('present') }
        it { is_expected.to contain_package('zabbix-server-pgsql').with_name('zabbix-server-pgsql') }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_require('Package[zabbix-server-pgsql]') }
      end

      describe 'with database_type as mysql' do
        let :params do
          {
            database_type: 'mysql'
          }
        end

        it { is_expected.to contain_package('zabbix-server-mysql').with_ensure('present') }
        it { is_expected.to contain_package('zabbix-server-mysql').with_name('zabbix-server-mysql') }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_require('Package[zabbix-server-mysql]') }
      end

      # Include directory should be available.
      it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf.d').with_ensure('directory') }
      it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf.d').with_require('File[/etc/zabbix/zabbix_server.conf]') }

      context 'with zabbix::database::postgresql class' do
        let :params do
          {
            database_type: 'postgresql',
            database_user: 'zabbix-server',
            database_password: 'zabbix-server',
            database_host: 'localhost',
            database_name: 'zabbix-server'
          }
        end

        it { is_expected.to contain_class('zabbix::database::postgresql').with_zabbix_type('server') }
        it { is_expected.to contain_class('zabbix::database::postgresql').with_zabbix_version('3.2') }
        it { is_expected.to contain_class('zabbix::database::postgresql').with_database_name('zabbix-server') }
        it { is_expected.to contain_class('zabbix::database::postgresql').with_database_user('zabbix-server') }
        it { is_expected.to contain_class('zabbix::database::postgresql').with_database_password('zabbix-server') }
        it { is_expected.to contain_class('zabbix::database::postgresql').with_database_host('localhost') }
      end

      context 'with zabbix::database::mysql class' do
        let :params do
          {
            database_type: 'mysql',
            database_user: 'zabbix-server',
            database_password: 'zabbix-server',
            database_host: 'localhost',
            database_name: 'zabbix-server'
          }
        end

        it { is_expected.to contain_class('zabbix::database::mysql').with_zabbix_type('server') }
        it { is_expected.to contain_class('zabbix::database::mysql').with_zabbix_version('3.2') }
        it { is_expected.to contain_class('zabbix::database::mysql').with_database_name('zabbix-server') }
        it { is_expected.to contain_class('zabbix::database::mysql').with_database_user('zabbix-server') }
        it { is_expected.to contain_class('zabbix::database::mysql').with_database_password('zabbix-server') }
        it { is_expected.to contain_class('zabbix::database::mysql').with_database_host('localhost') }
      end

      # So if manage_firewall is set to true, it should install
      # the firewall rule.
      context 'when declaring manage_firewall is true' do
        let :params do
          {
            manage_firewall: true
          }
        end

        it { is_expected.to contain_firewall('151 zabbix-server') }
      end

      context 'when declaring manage_firewall is false' do
        let :params do
          {
            manage_firewall: false
          }
        end

        it { is_expected.not_to contain_firewall('151 zabbix-server') }
      end

      # If manage_service is true (default), it should create a service
      # and ensure that it is running.
      context 'when declaring manage_service is true' do
        let :params do
          {
            manage_service: true
          }
        end

        it { is_expected.to contain_service('zabbix-server').with_ensure('running') }
      end

      # When the manage_service is false, it may not make the service.
      context 'when declaring manage_service is false' do
        let :params do
          {
            manage_service: false
          }
        end

        it { is_expected.not_to contain_service('zabbix-server') }
      end

      context 'with all zabbix_server.conf-related parameters' do
        let :params do
          {
            alertscriptspath: '${datadir}/zabbix/alertscripts',
            allowroot: '1',
            cachesize: '8M',
            cacheupdatefrequency: '30',
            database_host: 'localhost',
            database_name: 'zabbix-server',
            database_password: 'zabbix-server',
            database_port: '3306',
            database_schema: 'zabbix-server',
            database_socket: '/tmp/socket.db',
            database_user: 'zabbix-server',
            debuglevel: '3',
            externalscripts: '/usr/lib/zabbix/externalscripts0',
            fping6location: '/usr/sbin/fping6',
            fpinglocation: '/usr/sbin/fping',
            historycachesize: '4M',
            historytextcachesize: '4M',
            housekeepingfrequency: '1',
            include_dir: '/etc/zabbix/zabbix_server.conf.d',
            javagateway: '192.168.2.2',
            javagatewayport: '10052',
            listenip: '192.168.1.1',
            listenport: '10051',
            loadmodulepath: '${libdir}/modules',
            loadmodule: 'pizza',
            logfilesize: '10',
            logfile: '/var/log/zabbix/zabbix_server.log',
            logslowqueries: '0',
            maxhousekeeperdelete: '500',
            nodeid: '0',
            nodenoevents: '0',
            nodenohistory: '0',
            pidfile: '/var/run/zabbix/zabbix_server.pid',
            proxyconfigfrequency: '3600',
            proxydatafrequency: '1',
            senderfrequency: '30',
            snmptrapperfile: '/tmp/zabbix_traps.tmp',
            sourceip: '192.168.1.1',
            sshkeylocation: '/home/zabbix',
            startdbsyncers: '4',
            startdiscoverers: '1',
            starthttppollers: '1',
            startipmipollers: '12',
            startpingers: '1',
            startpollers: '12',
            startpollersunreachable: '1',
            startproxypollers: '1',
            startsnmptrapper: '1',
            starttimers: '1',
            starttrappers: '5',
            startvmwarecollectors: '5',
            timeout: '3',
            tmpdir: '/tmp',
            trappertimeout: '30',
            trendcachesize: '4M',
            unavailabledelay: '30',
            unreachabledelay: '30',
            unreachableperiod: '30',
            valuecachesize: '4M',
            vmwarecachesize: '8M',
            vmwarefrequency: '60',
            zabbix_version: '2.2'
          }
        end

        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^AlertScriptsPath=\$\{datadir\}/zabbix/alertscripts} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^AllowRoot=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^CacheSize=8M} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^CacheUpdateFrequency=30} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBHost=localhost} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBName=zabbix-server} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBPassword=zabbix-server} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBPort=3306} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBSchema=zabbix-server} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBSocket=/tmp/socket.db} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DBUser=zabbix-server} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^DebugLevel=3} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ExternalScripts=/usr/lib/zabbix/externalscripts} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^Fping6Location=/usr/sbin/fping6} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^FpingLocation=/usr/sbin/fping} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^HistoryCacheSize=4M} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^HistoryTextCacheSize=4M} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^HousekeepingFrequency=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^Include=/etc/zabbix/zabbix_server.conf.d} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^JavaGateway=192.168.2.2} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^JavaGatewayPort=10052} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ListenIP=192.168.1.1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ListenPort=10051$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LoadModulePath=\$\{libdir\}/modules} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LoadModule = pizza} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LogFileSize=10} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LogFile=/var/log/zabbix/zabbix_server.log} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^LogSlowQueries=0} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^MaxHousekeeperDelete=500} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeID=0$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeNoEvents=0} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeNoHistory=0} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^PidFile=/var/run/zabbix/zabbix_server.pid} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ProxyConfigFrequency=3600} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ProxyDataFrequency=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^SenderFrequency=30} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^SNMPTrapperFile=/tmp/zabbix_traps.tmp} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^SourceIP=192.168.1.1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^SSHKeyLocation=/home/zabbix} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartDBSyncers=4} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartDiscoverers=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartHTTPPollers=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartIPMIPollers=12} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartPingers=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartPollers=12} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartPollersUnreachable=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartProxyPollers=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartSNMPTrapper=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartTimers=1} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartTrappers=5} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^StartVMwareCollectors=5} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^Timeout=3} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TmpDir=/tmp} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TrapperTimeout=30} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TrendCacheSize=4M} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^UnavailableDelay=30} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^UnreachableDelay=30} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^UnreachablePeriod=30} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^ValueCacheSize=4M} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^VMwareCacheSize=8M} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^VMwareFrequency=60} }
      end

      context 'with zabbix_server.conf and version 2.4' do
        let :params do
          {
            nodeid: '0',
            nodenohistory: '0',
            nodenoevents: '0',
            zabbix_version: '2.4'
          }
        end

        it { is_expected.not_to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeID=0$} }
        it { is_expected.not_to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeNoEvents=0} }
        it { is_expected.not_to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^NodeNoHistory=0} }
      end

      context 'with zabbix_server.conf and version 3.0' do
        let :params do
          {
            tlscafile: '/etc/zabbix/keys/zabbix-server.ca',
            tlscrlfile: '/etc/zabbix/keys/zabbix-server.crl',
            tlscertfile: '/etc/zabbix/keys/zabbix-server.crt',
            tlskeyfile: '/etc/zabbix/keys/zabbix-server.key',
            zabbix_version: '3.0'
          }
        end

        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TLSCAFile=/etc/zabbix/keys/zabbix-server.ca$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TLSCRLFile=/etc/zabbix/keys/zabbix-server.crl$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TLSCertFile=/etc/zabbix/keys/zabbix-server.crt$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TLSKeyFile=/etc/zabbix/keys/zabbix-server.key$} }
      end
      context 'with zabbix_server.conf and version 3.2' do
        let :params do
          {
            tlscafile: '/etc/zabbix/keys/zabbix-server.ca',
            tlscrlfile: '/etc/zabbix/keys/zabbix-server.crl',
            tlscertfile: '/etc/zabbix/keys/zabbix-server.crt',
            tlskeyfile: '/etc/zabbix/keys/zabbix-server.key',
            zabbix_version: '3.2'
          }
        end

        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TLSCAFile=/etc/zabbix/keys/zabbix-server.ca$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TLSCRLFile=/etc/zabbix/keys/zabbix-server.crl$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TLSCertFile=/etc/zabbix/keys/zabbix-server.crt$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_server.conf').with_content %r{^TLSKeyFile=/etc/zabbix/keys/zabbix-server.key$} }
      end
    end
  end
end
