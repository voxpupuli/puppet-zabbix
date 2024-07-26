# frozen_string_literal: true

require 'spec_helper'
Package = Puppet::Util::Package

describe 'zabbix::sender' do
  let :node do
    'agent.example.com'
  end

  on_supported_os.each do |os, facts|
    next if facts[:os]['name'] == 'windows'

    context "on #{os}" do
      let :facts do
        facts
      end

      zabbix_version = if facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'] == '7'
                         '5.0'
                       else
                         '6.0'
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

        if %w[Archlinux Gentoo FreeBSD].include?(facts[:os]['family'])
          it { is_expected.not_to compile.with_all_deps }
        else
          it { is_expected.to contain_class('zabbix::repo').with_zabbix_version(zabbix_version) }
          it { is_expected.to contain_package('zabbix-sender').with_require('Class[Zabbix::Repo]') }
        end

        case facts[:os]['family']
        when 'RedHat'
          it { is_expected.to contain_yumrepo('zabbix-nonsupported') }
          it { is_expected.to contain_yumrepo('zabbix') }

          it { is_expected.to contain_yumrepo('zabbix-frontend') }          if facts[:os]['release']['major'] == '7'
          it { is_expected.to contain_package('zabbix-required-scl-repo') } if facts[:os]['release']['major'] == '7' && %w[OracleLinux CentOS].include?(facts[:os]['name'])
        when 'Debian'
          it { is_expected.to contain_apt__source('zabbix') }

          it { is_expected.to contain_apt__key('zabbix-A1848F5') }               if (facts[:os]['name'] == 'Debian' && Package.versioncmp(facts[:os]['release']['major'], '12') < 0) || (facts[:os]['name'] == 'Ubuntu' && Package.versioncmp(facts[:os]['release']['major'], '22.04') < 0)
          it { is_expected.to contain_apt__key('zabbix-FBABD5F') }               if (facts[:os]['name'] == 'Debian' && Package.versioncmp(facts[:os]['release']['major'], '12') < 0) || (facts[:os]['name'] == 'Ubuntu' && Package.versioncmp(facts[:os]['release']['major'], '22.04') < 0)
          it { is_expected.to contain_apt__keyring('zabbix-official-repo.asc') } if (facts[:os]['name'] == 'Debian' && Package.versioncmp(facts[:os]['release']['major'], '12') >= 0) || (facts[:os]['name'] == 'Ubuntu' && Package.versioncmp(facts[:os]['release']['major'], '22.04') >= 0)
        end
      end
    end
  end
end
