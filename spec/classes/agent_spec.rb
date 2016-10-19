require 'spec_helper'

describe 'zabbix::agent' do
  let :node do
    'agent.example.com'
  end
  let :params do
    {
      server: '192.168.1.1',
      serveractive: '192.168.1.1',
      agent_configfile_path: '/etc/zabbix/zabbix_agentd.conf'
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os} " do
      systemd_fact = case facts[:osfamily]
                     when 'Archlinux','Fedora'
                       { systemd: true }
                     else
                       { systemd: false }
                     end
      let :facts do
        facts.merge(systemd_fact)
      end

      context 'with all defaults' do
        package = case facts[:osfamily]
                  when 'Archlinux'
                    'zabbix3-agent'
                  else
                    'zabbix-agent'
                  end
        # Make sure package will be installed, service running and ensure of directory.
        it do
          should contain_package(package).with(
            ensure:   'present',
            require:  'Class[Zabbix::Repo]',
            tag:      'zabbix'
          )
        end

        it do
          should contain_service('zabbix-agent').with(
            ensure:     'running',
            enable:     true,
            hasstatus:  true,
            hasrestart: true,
            require:    "Package[#{package}]"
          )
        end

        it { should contain_file('/etc/zabbix/zabbix_agentd.d').with_ensure('directory') }
        it { should contain_zabbix__startup('zabbix-agent').that_requires("Package[#{package}]") }
      end

      context 'when declaring manage_repo is true' do
        let :params do
          {
            manage_repo: true
          }
        end

        case facts[:osfamily]
        when 'Archlinux'
          it { should raise_error(Puppet::Error, %r{Managing a repo on Archlinux is currently not implemented}) }
        else
          it { should contain_class('zabbix::repo').with_zabbix_version('3.0') }
          it { should contain_package('zabbix-agent').with_require('Class[Zabbix::Repo]') }
        end
      end

      context 'when declaring manage_resources is true' do
        let :params do
          {
            manage_resources: true
          }
        end

        it { should contain_class('zabbix::resources::agent') }
      end

      context 'configuration file with hostnameitem' do
        let :params do
          {
            hostnameitem: 'system.hostname'
          }
        end

        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^HostnameItem=system.hostname$} }
      end

      context 'when declaring manage_firewall is true' do
        let :params do
          {
            manage_firewall: true
          }
        end

        it { should contain_firewall('150 zabbix-agent') }
      end

      context 'when declaring manage_firewall is false' do
        let :params do
          {
            manage_firewall: false
          }
        end

        it { should_not contain_firewall('150 zabbix-agent') }
      end

      context 'configuration file with full options' do
        let :params do
          {
            allowroot: '0',
            agent_configfile_path: '/etc/zabbix/zabbix_agentd.conf',
            buffersend: '5',
            buffersize: '100',
            debuglevel: '4',
            enableremotecommands: '1',
            hostname: '10050',
            include_dir: '/etc/zabbix/zabbix_agentd.d',
            listenport: '10050',
            loadmodulepath: '${libdir}/modules',
            logfilesize: '4',
            logfile: '/var/log/zabbix/zabbix_agentd.log',
            logremotecommands: '0',
            pidfile: '/var/run/zabbix/zabbix_agentd.pid',
            refreshactivechecks: '120',
            server: '192.168.1.1',
            serveractive: '192.168.1.1',
            startagents: '3',
            timeout: '30',
            unsafeuserparameters: '0',
            tlsconnect: 'cert',
            tlsaccept: 'cert',
            tlscafile: '/etc/zabbix/keys/file.ca',
            tlscrlfile: '/etc/zabbix/keys/file.crl',
            tlsservercertissuer: 'Zabbix.Com',
            tlsservercertsubject: 'MySubJect',
            tlscertfile: '/etc/zabbix/keys/tls.crt',
            tlskeyfile: '/etc/zabbix/keys/tls.key',
            tlspskidentity: '/etc/zabbix/keys/tlspskidentity.id',
            tlspskfile: '/etc/zabbix/keys/tlspskfile.key'
          }
        end

        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^AllowRoot=0$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^BufferSend=5$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^BufferSize=100$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^DebugLevel=4$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^EnableRemoteCommands=1$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Hostname=10050$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Include=/etc/zabbix/zabbix_agentd.d$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ListenPort=10050$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LoadModulePath=\$\{libdir\}/modules$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogFileSize=4$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogFile=/var/log/zabbix/zabbix_agentd.log$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogRemoteCommands=0$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^PidFile=/var/run/zabbix/zabbix_agentd.pid$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^RefreshActiveChecks=120$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Server=192.168.1.1$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ServerActive=192.168.1.1$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^StartAgents=3$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Timeout=30$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^UnsafeUserParameters=0$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSConnect=cert$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSAccept=cert$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCAFile=/etc/zabbix/keys/file.ca$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCRLFile=/etc/zabbix/keys/file.crl$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSServerCertIssuer=Zabbix.Com$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSServerCertSubject=MySubJect$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCertFile=/etc/zabbix/keys/tls.crt$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSKeyFile=/etc/zabbix/keys/tls.key$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSPSKIdentity=/etc/zabbix/keys/tlspskidentity.id$} }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSPSKFile=/etc/zabbix/keys/tlspskfile.key$} }
      end
    end
  end
end
