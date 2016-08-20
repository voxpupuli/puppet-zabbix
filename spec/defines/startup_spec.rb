require 'spec_helper'

describe 'zabbix::startup', type: :define do
  let(:title) { 'zabbix-agent' }

  %w(RedHat Debian).each do |osfamily|
    context "on #{osfamily}" do
      context 'no systemd' do
        ['false', false].each do |systemd_fact_state|
          let :facts do
            {
              osfamily: osfamily,
              systemd: systemd_fact_state,
            }
          end
          it { should_not contain_class('systemd') }
          it { should_not contain_file('/etc/systemd/system/zabbix-agent.service') }
          it { should contain_file('/etc/init.d/zabbix-agent').with_ensure('file') }
        end
      end

      context 'has systemd' do
        ['true', true].each do |systemd_fact_state|
          let :facts do
            {
              osfamily: osfamily,
              systemd: systemd_fact_state,
            }
          end
          it { should contain_class('systemd') }
          it { should contain_file('/etc/systemd/system/zabbix-agent.service') }
          it { should contain_file('/etc/init.d/zabbix-agent').with_ensure('absent') }
        end
      end
    end
  end
end
