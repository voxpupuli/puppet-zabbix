require 'spec_helper'

describe 'zabbix::sender' do
  let :node do
    'agent.example.com'
  end

  on_supported_os(baseline_os_hash).each do |os, facts|
    next if facts[:os]['name'] == 'windows'
    context "on #{os} " do
      let :facts do
        facts
      end

      context 'with all defaults' do
        it { is_expected.to contain_class('zabbix::sender') }
        it { is_expected.to contain_class('zabbix::params') }
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
          it { is_expected.to contain_class('zabbix::repo').with_zabbix_version('5.0') }
          it { is_expected.to contain_package('zabbix-sender').with_require('Class[Zabbix::Repo]') }
        end

        case facts[:os]['family']
        when 'RedHat'
          it { is_expected.to contain_yumrepo('zabbix-nonsupported') }
          it { is_expected.to contain_yumrepo('zabbix') }
        when 'Debian'
          it { is_expected.to contain_apt__source('zabbix') }
          it { is_expected.to contain_apt__key('zabbix-A1848F5') }
          it { is_expected.to contain_apt__key('zabbix-FBABD5F') }
        end
      end
    end
  end
end
