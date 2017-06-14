require 'spec_helper'

describe 'zabbix::startup', type: :define do # rubocop:disable RSpec/MultipleDescribes
  let(:title) { 'zabbix-agent' }

  %w[RedHat Debian Gentoo Archlinux].each do |osfamily|
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
              pidfile: '/somethingelse',
              additional_service_params: '--foreground'
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
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-agent.service').with_content(%r{ExecStart=/usr/sbin/zabbix_agentd --foreground -c /something}) }
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-agent.service').with_content(%r{PIDFile=/somethingelse}) }
        end
      end
    end
  end
end
describe 'zabbix::startup', type: :define do
  let(:title) { 'zabbix-server' }

  %w[RedHat Debian Gentoo].each do |osfamily|
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
                database_type: 'mysql',
                manage_database: true
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
              database_type: 'mysql',
              additional_service_params: '--foreground',
              manage_database: true
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
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with_content(%r{ExecStart=/usr/sbin/zabbix_server --foreground -c /something}) }
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with_content(%r{PIDFile=/somethingelse}) }
          it { is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with_content(%r{After=mysqld.service}) }

          context 'and works on postgres' do
            let :params do
              {
                server_configfile_path: '/something',
                pidfile: '/somethingelse',
                database_type: 'postgresql',
                manage_database: true
              }
            end

            it { is_expected.to contain_file('/etc/systemd/system/zabbix-server.service').with_content(%r{After=postgresql.service}) }
          end
        end
      end
    end
  end
end
