# frozen_string_literal: true

require 'deep_merge'
require 'spec_helper'

describe 'zabbix::repo' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'Archlinux', 'FreeBSD', 'Gentoo', 'AIX'
        # rubocop:disable RSpec/RepeatedExample
        it { is_expected.to compile.with_all_deps }
      when 'Debian'

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('zabbix::params') }
        it { is_expected.to contain_class('zabbix::repo') }

        it { is_expected.to contain_apt__key('zabbix-A1848F5') }               if (facts[:os]['name'] == 'Debian' && Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '12') < 0) || (facts[:os]['name'] == 'Ubuntu' && Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '22.04') < 0)
        it { is_expected.to contain_apt__key('zabbix-FBABD5F') }               if (facts[:os]['name'] == 'Debian' && Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '12') < 0) || (facts[:os]['name'] == 'Ubuntu' && Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '22.04') < 0)
        it { is_expected.to contain_apt__keyring('zabbix-official-repo.asc') } if (facts[:os]['name'] == 'Debian' && Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '12') >= 0) || (facts[:os]['name'] == 'Ubuntu' && Puppet::Util::Package.versioncmp(facts[:os]['release']['major'], '22.04') >= 0)

        context 'when repo_location is "https://example.com/foo"' do
          let :params do
            {
              repo_location: 'https://example.com/foo'
            }
          end

          it { is_expected.to contain_apt__source('zabbix').with_location('https://example.com/foo') }
        end

        case facts[:os]['release']['major']
        when '10'
          context 'on Debian 10 and Zabbix 5.0' do
            let :params do
              {
                zabbix_version: '5.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/5.0/debian/') }
          end
        end

        %w[arm64 aarch64].each do |arch|
          context "on #{arch}" do
            let :facts do
              facts.deep_merge(os: { architecture: arch })
            end

            it { is_expected.to contain_apt__source('zabbix').with_location("http://repo.zabbix.com/zabbix/6.0/#{facts[:os]['name'].downcase}-arm64/") }
          end
        end
      when 'RedHat'

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('zabbix::params') }
        it { is_expected.to contain_class('zabbix::repo') }
        # rubocop:enable RSpec/RepeatedExample

        context 'when repo_location is "https://example.com/foo"' do
          let :params do
            {
              repo_location: 'https://example.com/foo'
            }
          end

          it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://example.com/foo') }
        end

        context 'when unsupported_repo_location is "https://example.com/foo"' do
          let :params do
            {
              unsupported_repo_location: 'https://example.com/foo'
            }
          end

          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://example.com/foo') }
        end

        case facts[:os]['release']['major']
        when '7'
          context 'on RedHat 7 and Zabbix 5.0' do
            let :params do
              {
                zabbix_version: '5.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/5.0/rhel/7/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/7/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-79EA5ED4') }
            it { is_expected.to contain_yumrepo('zabbix-frontend') }

            it { is_expected.to contain_package('zabbix-required-scl-repo').with_ensure('latest').with_name('centos-release-scl') } if facts[:os]['name'] == 'CentOS'
            it { is_expected.to contain_package('zabbix-required-scl-repo').with_ensure('latest').with_name('oracle-softwarecollection-release-el7') } if facts[:os]['name'] == 'OracleLinux'
          end
        when '9'

          context 'on RedHat 9 and Zabbix 5.0' do
            let :params do
              {
                zabbix_version: '5.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/5.0/rhel/9/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/9/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') }
          end

          context 'on RedHat 9 and Zabbix 6.0' do
            let :params do
              {
                zabbix_version: '6.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/6.0/rhel/9/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/9/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') }
          end
        end
      end
    end
  end
end
