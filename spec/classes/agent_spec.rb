# frozen_string_literal: true

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
    context "on #{os}" do
      config_path = case facts[:os]['name']
                    when 'windows'
                      'C:/ProgramData/zabbix/zabbix_agentd.conf'
                    when 'FreeBSD'
                      '/usr/local/etc/zabbix6/zabbix_agentd.conf'
                    else
                      '/etc/zabbix/zabbix_agentd.conf'
                    end

      log_path = case facts[:os]['name']
                 when 'windows'
                   'C:/ProgramData/zabbix/zabbix_agentd.log'
                 else
                   '/var/log/zabbix/zabbix_agentd.log'
                 end
      include_dir = case facts[:os]['name']
                    when 'windows'
                      'C:/ProgramData/zabbix/zabbix_agentd.d'
                    when 'FreeBSD'
                      '/usr/local/etc/zabbix6/zabbix_agentd.d'
                    else
                      '/etc/zabbix/zabbix_agentd.d'
                    end
      let(:facts) { facts }

      zabbix_version = '6.0'

      case facts[:os]['family']
      when 'Gentoo'
        package_name = 'zabbix'
        service_name = 'zabbix-agentd'
      when 'windows'
        package_name = 'zabbix-agent'
        service_name = 'Zabbix Agent'
      when 'FreeBSD'
        package_name = 'zabbix6-agent'
        service_name = 'zabbix_agentd'
      else
        package_name = 'zabbix-agent'
        service_name = 'zabbix-agent'
      end
      # package = facts[:os]['family'] == 'Gentoo' ? 'zabbix' : 'zabbix-agent'
      # service = facts[:os]['family'] == 'Gentoo' ? 'zabbix-agentd' : 'zabbix-agent'

      context 'with all defaults' do
        it { is_expected.to contain_selinux__module('zabbix-agent') }            if facts[:os]['family'] == 'RedHat'
        it { is_expected.to contain_apt__key('zabbix-A1848F5') }                 if facts[:os]['family'] == 'Debian'
        it { is_expected.to contain_apt__key('zabbix-FBABD5F') }                 if facts[:os]['family'] == 'Debian'
        it { is_expected.to contain_file(include_dir).with_ensure('directory') }

        # Make sure package will be installed, service running and ensure of directory.
        if facts[:os]['name'] == 'windows'
          it do
            is_expected.to contain_package(package_name).with(
              ensure: '4.4.5',
              provider: 'chocolatey',
              tag: 'zabbix'
            )
          end
        else

          if facts[:os]['family'] == 'Gentoo'
            it do
              is_expected.to contain_package(package_name).
                with_ensure('present').
                with_tag('zabbix')
            end
          else
            it do
              is_expected.to contain_package(package_name).
                with_ensure('present').
                with_tag('zabbix').
                that_requires('Class[zabbix::repo]')
            end
          end

          it do
            is_expected.to contain_service(service_name).
              with_ensure('running').
              with_enable(true).
              with_service_provider(facts[:os]['family'] == 'AIX' ? 'init' : nil)
          end

          it { is_expected.not_to contain_zabbix__startup(service_name) }
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('zabbix::params') }
        end
      end

      context 'when declaring manage_repo is true' do
        let :params do
          {
            manage_repo: true
          }
        end

        case facts[:os]['family']
        when %w[Archlinux Gentoo FreeBSD].include?(facts[:os]['family'])
          it { is_expected.not_to compile.with_all_deps }
        when 'Debian'
          # rubocop:disable RSpec/RepeatedExample
          it { is_expected.to contain_class('zabbix::repo').with_zabbix_version(zabbix_version) }
          it { is_expected.to contain_package('zabbix-agent').that_requires('Class[Zabbix::Repo]') }
          it { is_expected.to contain_apt__source('zabbix') }
        when 'RedHat'
          it { is_expected.to contain_class('zabbix::repo').with_zabbix_version(zabbix_version) }
          it { is_expected.to contain_package('zabbix-agent').that_requires('Class[Zabbix::Repo]') }
          it { is_expected.to contain_yumrepo('zabbix-nonsupported') }
          it { is_expected.to contain_yumrepo('zabbix') }
          # rubocop:enable RSpec/RepeatedExample
        end
      end

      context 'when declaring manage_resources is true' do
        let :params do
          {
            manage_resources: true
          }
        end

        it { is_expected.to contain_class('zabbix::resources::agent') }
      end

      context 'configuration file with hostnameitem' do
        let :params do
          {
            hostnameitem: 'system.hostname'
          }
        end

        it { is_expected.to contain_file(config_path).with_content %r{^HostnameItem=system.hostname$} }
      end

      context 'ignores hostnameitem if hostname is set' do
        let :params do
          {
            hostname: 'test',
            hostnameitem: 'system.hostname'
          }
        end

        it { is_expected.to contain_file(config_path).without_content %r{^HostnameItem=system.hostname$} }
        it { is_expected.to contain_file(config_path).with_content %r{^Hostname=test$} }
      end

      context 'configuration file with hostinterfaceitem' do
        let :params do
          {
            hostinterfaceitem: 'system.hostname'
          }
        end

        it { is_expected.to contain_file(config_path).with_content %r{^HostInterfaceItem=system.hostname$} }
      end

      context 'configuration file with hostinterface' do
        let :params do
          {
            hostinterface: 'testinterface'
          }
        end

        it { is_expected.to contain_file(config_path).with_content %r{^HostInterface=testinterface$} }
      end

      context 'when declaring manage_firewall is true with single server' do
        let :params do
          {
            server: '192.168.1.1',
            manage_firewall: true
          }
        end

        it { is_expected.to contain_firewall('150 zabbix-agent from 192.168.1.1') }
      end

      context 'when declaring manage_firewall is false with single server' do
        let :params do
          {
            server: '192.168.1.1',
            manage_firewall: false
          }
        end

        it { is_expected.not_to contain_firewall('150 zabbix-agent from 192.168.1.1') }
      end

      context 'when declaring manage_firewall is true with multiple servers' do
        let :params do
          {
            server: '192.168.1.1,10.11.12.13',
            manage_firewall: true
          }
        end

        it { is_expected.to contain_firewall('150 zabbix-agent from 192.168.1.1') }
        it { is_expected.to contain_firewall('150 zabbix-agent from 10.11.12.13') }
      end

      context 'when declaring manage_firewall is false with multiple servers' do
        let :params do
          {
            server: '192.168.1.1,10.11.12.13',
            manage_firewall: false
          }
        end

        it { is_expected.not_to contain_firewall('150 zabbix-agent from 192.168.1.1') }
        it { is_expected.not_to contain_firewall('150 zabbix-agent from 10.11.12.13') }
      end

      context 'when declaring manage_startup_script is true' do
        next if facts[:os]['family'] == 'FreeBSD'
        next if facts[:os]['family'] == 'Gentoo'

        let :params do
          {
            manage_startup_script: true
          }
        end

        context 'it creates a startup script' do
          if facts[:kernel] == 'Linux'
            case facts[:os]['family']
            when 'Archlinux', 'Debian', 'Gentoo', 'RedHat'
              it { is_expected.to contain_file("/etc/init.d/#{service_name}").with_ensure('absent') }
              it { is_expected.to contain_file("/etc/systemd/system/#{service_name}.service").with_ensure('file') }
            when 'windows'
              it { is_expected.to contain_exec("install_agent_#{service_name}") }
            else
              it { is_expected.to contain_file("/etc/init.d/#{service_name}").with_ensure('file') }
              it { is_expected.not_to contain_file("/etc/systemd/system/#{service_name}.service") }
            end
          end
        end

        it do
          is_expected.to contain_service(service_name).
            with_ensure('running').
            with_enable(true).
            with_service_provider(facts[:os]['family'] == 'AIX' ? 'init' : nil).
            that_requires(["Package[#{package_name}]", "Zabbix::Startup[#{service_name}]"])
        end

        it { is_expected.to contain_zabbix__startup(service_name).that_requires("Package[#{package_name}]") }
      end

      context 'when declaring zabbix_alias' do
        let :params do
          {
            zabbix_alias: %w[testname]
          }
        end

        it { is_expected.to contain_file(config_path).with_content %r{^Alias=testname$} }
      end

      context 'when declaring zabbix_alias as array' do
        let :params do
          {
            zabbix_alias: %w[name1 name2]
          }
        end

        it { is_expected.to contain_file(config_path).with_content %r{^Alias=name1$} }
        it { is_expected.to contain_file(config_path).with_content %r{^Alias=name2$} }
      end

      context 'configuration file with full options' do
        if facts[:kernel] == 'Linux'
          let :params do
            {
              allowroot: '0',
              agent_configfile_path: '/etc/zabbix/zabbix_agentd.conf',
              buffersend: '5',
              buffersize: '100',
              controlsocket: '/tmp/agent.sock',
              debuglevel: '4',
              allowkey: 'system.run[*]',
              denykey: 'system.run[*]',
              enableremotecommands: '1',
              hostname: '10050',
              include_dir: '/etc/zabbix/zabbix_agentd.d',
              listenport: '10050',
              listenip: '127.0.0.1',
              loadmodulepath: '${libdir}/modules',
              logfilesize: '4',
              logfile: '/var/log/zabbix/zabbix_agentd.log',
              logtype: 'file',
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
              tlspskfile: '/etc/zabbix/keys/tlspskfile.key',
              tlsciphercert: 'EECDH+aRSA+AES128:RSA+aRSA+AES128',
              tlsciphercert13: 'EECDH+aRSA+AES128:RSA+aRSA+AES128',
              tlscipherpsk: 'kECDHEPSK+AES128:kPSK+AES128',
              tlscipherpsk13: 'TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256',
              tlscipherall: 'TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256',
              tlscipherall13: 'EECDH+aRSA+AES128:RSA+aRSA+AES128:kECDHEPSK+AES128:kPSK+AES128'
            }
          end

          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^AllowRoot=0$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^BufferSend=5$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^BufferSize=100$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ControlSocket=/tmp/agent.sock$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^DebugLevel=4$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^AllowKey=system.run\[\*\]$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^DenyKey=system.run\[\*\]$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Hostname=10050$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Include=/etc/zabbix/zabbix_agentd.d$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ListenPort=10050$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ListenIP=127.0.0.1$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LoadModulePath=\$\{libdir\}/modules$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogFileSize=4$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogFile=/var/log/zabbix/zabbix_agentd.log$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogType=file$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^LogRemoteCommands=0$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^PidFile=/var/run/zabbix/zabbix_agentd.pid$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^RefreshActiveChecks=120$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Server=192.168.1.1$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ServerActive=192.168.1.1$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^StartAgents=3$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Timeout=30$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^UnsafeUserParameters=0$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSConnect=cert$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSAccept=cert$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCAFile=/etc/zabbix/keys/file.ca$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCRLFile=/etc/zabbix/keys/file.crl$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSServerCertIssuer=Zabbix.Com$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSServerCertSubject=MySubJect$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCertFile=/etc/zabbix/keys/tls.crt$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSKeyFile=/etc/zabbix/keys/tls.key$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSPSKIdentity=/etc/zabbix/keys/tlspskidentity.id$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSPSKFile=/etc/zabbix/keys/tlspskfile.key$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCipherCert=EECDH\+aRSA\+AES128:RSA\+aRSA\+AES128$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCipherCert13=EECDH\+aRSA\+AES128:RSA\+aRSA\+AES128$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCipherPSK=kECDHEPSK\+AES128:kPSK\+AES128$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCipherPSK13=TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCipherAll=TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256$} }
          it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^TLSCipherAll13=EECDH\+aRSA\+AES128:RSA\+aRSA\+AES128:kECDHEPSK\+AES128:kPSK\+AES128$} }
        end
      end

      context 'tlsaccept with one value array' do
        if facts[:kernel] == 'Linux'
          let :params do
            {
              tlsaccept: %w[cert]
            }
          end

          it { is_expected.to contain_file(config_path).with_content %r{^TLSAccept=cert$} }
        end
      end

      context 'tlsaccept with two value array' do
        if facts[:kernel] == 'Linux'
          let :params do
            {
              tlsaccept: %w[unencrypted cert]
            }
          end

          it { is_expected.to contain_file(config_path).with_content %r{^TLSAccept=unencrypted,cert$} }
        end
      end

      context 'without ListenIP' do
        let :params do
          {
            listenip: '*'
          }
        end

        it { is_expected.to contain_file(config_path).without_content %r{^ListenIP=} }
      end

      context 'when declaring service_ensure is stopped and service_enable false' do
        let :params do
          {
            service_ensure: 'stopped',
            service_enable: false
          }
        end

        it do
          is_expected.to contain_service(service_name).
            with_ensure('stopped').
            with_enable(false).
            that_requires("Package[#{package_name}]")
        end
      end

      context 'with zabbix_agentd.conf and logtype declared' do
        describe 'as system' do
          let :params do
            {
              logtype: 'system'
            }
          end

          it { is_expected.to contain_file(config_path).with_content %r{^LogType=system$} }
          it { is_expected.to contain_file(config_path).without_content %r{^LogFile=} }
          it { is_expected.to contain_file(config_path).without_content %r{^LogFileSize=} }
        end

        describe 'as console' do
          let :params do
            {
              logtype: 'console'
            }
          end

          it { is_expected.to contain_file(config_path).with_content %r{^LogType=console$} }
          it { is_expected.to contain_file(config_path).without_content %r{^LogFile=} }
          it { is_expected.to contain_file(config_path).without_content %r{^LogFileSize=} }
        end

        describe 'as file' do
          let :params do
            {
              logtype: 'file'
            }
          end

          it { is_expected.to contain_file(config_path).with_content %r{^LogType=file$} }
          it { is_expected.to contain_file(config_path).with_content %r{^LogFile=#{log_path}$} }
          it { is_expected.to contain_file(config_path).with_content %r{^LogFileSize=100$} }
        end
      end

      context 'when declaring manage_choco is false with zabbix_package_source specified' do
        if facts[:os]['name'] == 'windows'
          let :params do
            {
              manage_choco: false,
              zabbix_package_source: 'C:\\path\\to\\zabbix_installer.msi',
              zabbix_package_provider: 'windows'
            }
          end

          it do
            is_expected.to contain_package(package_name).
              with_ensure('present').
              with_tag('zabbix').
              with_provider('windows').
              with_source('C:\\path\\to\\zabbix_installer.msi')
          end
        end
      end

      describe 'with systemd active', skip: 'user package provided instead systemd::unit_file ' do
        if facts[:kernel] == 'Linux'
          let :facts do
            super().merge(systemd: true)
          end

          it { is_expected.to contain_systemd__unit_file('zabbix-agent.service') }
        end
      end

      context 'when zabbix_package_agent is zabbix-agent2' do
        next if facts[:os]['family'] == 'Gentoo'

        let :params do
          {
            zabbix_package_agent: 'zabbix-agent2', startagents: 1,
            maxlinespersecond: 1, allowroot: 1, zabbix_user: 'root',
            loadmodulepath: '/tmp', allowkey: 'system.run[*]',
            denykey: 'system.run[*]', enableremotecommands: 1,
            logremotecommands: 1, enablepersistentbuffer: 1,
            persistentbufferfile: '/var/lib/zabbix/zabbix_agent2.zbxtmp',
            persistentbufferperiod: '1h',
          }
        end

        it { is_expected.to contain_package('zabbix-agent2') }

        it do
          is_expected.not_to contain_file(config_path).with_content(
            %r{^(LogRemoteCommands|StartAgents|MaxLinesPerSecond
                 |AllowRoot|User|LoadModulePath|
                 EnableRemoteCommands|LogRemoteCommands|
                 EnablePersistentBuffer|PersistentBufferFile|
                 PersistentBufferPeriod)}
          )
        end
      end
    end
  end
end
