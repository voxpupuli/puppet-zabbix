require 'spec_helper'

describe 'zabbix::repo' do
  on_supported_os(baseline_os_hash).each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      case facts[:os]['family']
      when 'Archlinux'
        next
      when 'Debian'

        # rubocop:disable RSpec/RepeatedExample
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('zabbix::params') }
        it { is_expected.to contain_class('zabbix::repo') }

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
          context 'on Debian 10 and Zabbix 4.0' do
            let :params do
              {
                zabbix_version: '4.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/4.0/debian/') }
          end
          context 'on Debian 10 and Zabbix 5.0' do
            let :params do
              {
                zabbix_version: '5.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/5.0/debian/') }
          end
        when '16.04'
          context 'on Ubuntu 14.04 and Zabbix 5.0' do
            let :params do
              {
                zabbix_version: '5.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/5.0/ubuntu/') }
          end

          context 'on Ubuntu 16.04 and Zabbix 4.0' do
            let :params do
              {
                zabbix_version: '4.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/4.0/ubuntu/') }
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

          context 'on RedHat 7 and Zabbix 4.0' do
            let :params do
              {
                zabbix_version: '4.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/4.0/rhel/7/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/7/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-79EA5ED4') }
          end

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

            it { is_expected.to contain_package('zabbix-required-scl-repo').with_ensure('latest').with_name('centos-release-scl') }
          end
        end
      end
    end
  end
end
