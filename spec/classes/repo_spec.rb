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

        it { is_expected.to contain_apt__key('zabbix-A1848F5') } if facts[:os]['family'] == 'Debian'
        it { is_expected.to contain_apt__key('zabbix-FBABD5F') } if facts[:os]['family'] == 'Debian'

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

        context 'when repo_gpg_key_location is "https://example.com/bar"' do
          let :params do
            {
              repo_gpg_key_location: 'https://example.com/bar'
            }
          end

          it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://example.com/bar/RPM-GPG-KEY-ZABBIX-A14FE591') } if facts[:os]['release']['major'].to_i < 9
          it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://example.com/bar/RPM-GPG-KEY-ZABBIX-08EFA7DD') } if facts[:os]['release']['major'].to_i >= 9
        end

        context 'when unsupported_repo_location is "https://example.com/foo"' do
          let :params do
            {
              unsupported_repo_location: 'https://example.com/foo'
            }
          end

          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://example.com/foo') }
        end

        context 'when unsupported_repo_gpg_key_location is "https://example.com/bar"' do
          let :params do
            {
              unsupported_repo_gpg_key_location: 'https://example.com/bar'
            }
          end

          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://example.com/bar/RPM-GPG-KEY-ZABBIX-79EA5ED4') } if facts[:os]['release']['major'].to_i < 9
          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://example.com/bar/RPM-GPG-KEY-ZABBIX-08EFA7DD') } if facts[:os]['release']['major'].to_i >= 9
        end

        major = facts[:os]['release']['major']
        context "on RedHat #{major} and Zabbix 5.0" do
          let :params do
            {
              zabbix_version: '5.0',
              manage_repo: true
            }
          end

          it { is_expected.to contain_yumrepo('zabbix').with_baseurl("https://repo.zabbix.com/zabbix/5.0/rhel/#{major}/$basearch/") }

          it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') } if facts[:os]['release']['major'].to_i < 9
          it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') } if facts[:os]['release']['major'].to_i >= 9

          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl("https://repo.zabbix.com/non-supported/rhel/#{major}/$basearch/") }

          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-79EA5ED4') } if facts[:os]['release']['major'].to_i < 9
          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') } if facts[:os]['release']['major'].to_i >= 9
        end

        context "on RedHat #{major} and Zabbix 6.0" do
          let :params do
            {
              zabbix_version: '6.0',
              manage_repo: true
            }
          end

          it { is_expected.to contain_yumrepo('zabbix').with_baseurl("https://repo.zabbix.com/zabbix/6.0/rhel/#{major}/$basearch/") }

          it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') } if facts[:os]['release']['major'].to_i < 9
          it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') } if facts[:os]['release']['major'].to_i >= 9

          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl("https://repo.zabbix.com/non-supported/rhel/#{major}/$basearch/") }

          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-79EA5ED4') } if facts[:os]['release']['major'].to_i < 9
          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') } if facts[:os]['release']['major'].to_i >= 9
        end

        context "on RedHat #{major} and Zabbix 7.0" do
          let :params do
            {
              zabbix_version: '7.0',
              manage_repo: true
            }
          end

          it { is_expected.to contain_yumrepo('zabbix').with_baseurl("https://repo.zabbix.com/zabbix/7.0/rhel/#{major}/$basearch/") }
          it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005') }
          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl("https://repo.zabbix.com/non-supported/rhel/#{major}/$basearch/") }

          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005') } if facts[:os]['release']['major'].to_i < 9
          it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD') } if facts[:os]['release']['major'].to_i >= 9
        end
      end
    end
  end
end
