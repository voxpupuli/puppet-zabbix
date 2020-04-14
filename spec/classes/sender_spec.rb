require 'spec_helper'

describe 'zabbix::sender' do
  let :node do
    'agent.example.com'
  end

  on_supported_os.each do |os, facts|
    next if facts[:os]['name'] == 'windows'
    context "on #{os} " do
      let :facts do
        facts
      end

      context 'with all defaults' do
        it { is_expected.to contain_class('zabbix::sender') }
        it { is_expected.to compile.with_all_deps }
        # Make sure package will be installed, service running and ensure of directory.
        it { is_expected.to contain_package('zabbix-sender').with_ensure('present') }
        it { is_expected.to contain_package('zabbix-sender').with_name('zabbix-sender') }
      end
      context 'when declaring manage_repo is true' do
        let :params do
          {
            manage_repo: true
          }
        end

        if %w[Archlinux Gentoo].include?(facts[:osfamily])
          it { is_expected.not_to compile.with_all_deps }
        else
          it { is_expected.to contain_class('zabbix::repo').with_zabbix_version('3.4') }
          it { is_expected.to contain_package('zabbix-sender').with_require('Class[Zabbix::Repo]') }
        end
      end
    end
  end
end
