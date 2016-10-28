require 'spec_helper'

describe 'zabbix::startup', type: :define do # rubocop:disable RSpec/MultipleDescribes
  let(:title) { 'zabbix-agent' }

  %w(RedHat Debian Gentoo Archlinux).each do |osfamily|
    context "on #{osfamily}" do
      context 'on legacy init systems' do
        ['false', false].each do |systemd_fact_state|
          let :facts do
            {
              path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
              osfamily: osfamily,
              systemd: systemd_fact_state
            }
          end
          context 'it works' do
            let :params do
              {
                agent_configfile_path: '/something'
              }
            end
            if osfamily == 'Debian'
              it do
                is_expected.to contain_file('/etc/init.d/zabbix-agent').with(
                  ensure: 'file',
                  content: %r{DAEMON_OPTS="-c /something"}
                )
              end
            elsif osfamily == 'RedHat'
              it do
                is_expected.to contain_file('/etc/init.d/zabbix-agent').with(
                  ensure: 'file',
                  content: %r{OPTS="/something"}
                )
              end
            else
              it { is_expected.to raise_error(Puppet::Error, %r{We currently only support Debian and RedHat osfamily as non-systemd}) }
              next
            end
            it { is_expected.not_to contain_class('systemd') }
            it { is_expected.not_to contain_file('/etc/systemd/system/zabbix-agent.service') }
          end

          context 'it fails when agent_configfile_path param is missing' do
            let :params do
              {}
            end
            it { is_expected.to raise_error(Puppet::Error, %r{you have to provide a agent_configfile_path param}) }
          end
        end
      end
    end
    context 'on systemd' do
      ['true', true].each do |systemd_fact_state|
        let :facts do
          {
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
            osfamily: osfamily,
            systemd: systemd_fact_state
          }
        end
        context 'it works' do
          let :params do
            {
              agent_configfile_path: '/something',
              pidfile: '/somethingelse'
            }
          end
          it { is_expected.to contain_class('systemd') }
          it { is_expected.to contain_file('/etc/init.d/zabbix-agent').with_ensure('absent') }
          it do
            is_expected.to contain_file('/etc/systemd/system/zabbix-agent.service').with(
              ensure: 'file',
              mode:   '0664'
            ).that_notifies('Exec[systemctl-daemon-reload]')
          end
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-agent.service').with_content(%r{ExecStart=/usr/sbin/zabbix_agentd -c /something}) }
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-agent.service').with_content(%r{PIDFile=/somethingelse}) }
        end

        context 'it fails when pidfile param is missing' do
          let :params do
            {
              agent_configfile_path: '/something'
            }
          end
          it { is_expected.to raise_error(Puppet::Error, %r{you have to provide a pidfile param}) }
        end
      end
    end
  end
end
describe 'zabbix::startup', type: :define do
  let(:title) { 'zabbix-server' }
  %w(RedHat Debian Gentoo).each do |osfamily|
    context "on #{osfamily}" do
      context 'on legacy init systems' do
        ['false', false].each do |systemd_fact_state|
          let :facts do
            {
              path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
              osfamily: osfamily,
              systemd: systemd_fact_state
            }
          end
          context 'it works' do
            let :params do
              {
                server_configfile_path: '/something',
                database_type: 'mysql'
              }
            end
            if osfamily == 'Debian'
              it do
                is_expected.to contain_file('/etc/init.d/zabbix-server').with(
                  ensure: 'file',
                  content: %r{DAEMON_OPTS="-c /something"}
                )
              end
            elsif osfamily == 'RedHat'
              it do
                is_expected.to contain_file('/etc/init.d/zabbix-server').with(
                  ensure: 'file',
                  content: %r{OPTS="/something"}
                )
              end
            else
              it { is_expected.to raise_error(Puppet::Error, %r{We currently only support Debian and RedHat osfamily as non-systemd}) }
              next
            end
            it { is_expected.not_to contain_class('systemd') }
            it { is_expected.not_to contain_file('/etc/systemd/system/zabbix-server.service') }
          end

          context 'it fails when server_configfile_path param is missing' do
            let :params do
              {}
            end
            it { is_expected.to raise_error(Puppet::Error, %r{you have to provide a server_configfile_path param}) }
          end
        end
      end
    end
    context 'on systemd' do
      ['true', true].each do |systemd_fact_state|
        let :facts do
          {
            path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
            osfamily: osfamily,
            systemd: systemd_fact_state
          }
        end
        context 'it works on mysql' do
          let :params do
            {
              server_configfile_path: '/something',
              pidfile: '/somethingelse',
              database_type: 'mysql'
            }
          end
          it { is_expected.to contain_class('systemd') }
          it { is_expected.to contain_file('/etc/init.d/zabbix-server').with_ensure('absent') }
          it do
            is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with(
              ensure: 'file',
              mode:   '0664'
            ).that_notifies('Exec[systemctl-daemon-reload]')
          end
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with_content(%r{ExecStart=/usr/sbin/zabbix_server -c /something}) }
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with_content(%r{PIDFile=/somethingelse}) }
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with_content(%r{After=syslog.target network.target mysqld.service}) }

          context 'and works on postgres' do
            let :params do
              {
                server_configfile_path: '/something',
                pidfile: '/somethingelse',
                database_type: 'postgres'
              }
            end
            it { is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with_content(%r{After=syslog.target network.target postgresql.service}) }
          end
        end

        context 'it fails when database_type param is missing' do
          let :params do
            {
              server_configfile_path: '/something',
              pidfile: '/somethingelse'
            }
          end
          it { is_expected.to raise_error(Puppet::Error, %r{you have to provide a database_type param}) }
        end
      end
    end
  end
end
