require 'spec_helper'

describe 'zabbix::repo' do
  on_supported_os.each do |os, facts|
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

        case facts[:os]['release']['major']
        when '6'
          context 'on Debian 6 and Zabbix 2.0' do
            let :params do
              {
                zabbix_version: '2.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/debian/') }
          end

        when '7'
          context 'on Debian 7 and Zabbix 2.0' do
            let :params do
              {
                zabbix_version: '2.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/debian/') }
          end

          context 'on Debian 7 and Zabbix 2.2' do
            let :params do
              {
                zabbix_version: '2.2',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/debian/') }
          end

          context 'on Debian 7 and Zabbix 2.4' do
            let :params do
              {
                zabbix_version: '2.4',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.4/debian/') }
          end
        when '8'

          context 'on Debian 8 and Zabbix 3.0' do
            let :params do
              {
                zabbix_version: '3.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/3.0/debian/') }
          end
        when '12.04'
          context 'on Ubuntu 12.04 and Zabbix 2.0' do
            let :params do
              {
                zabbix_version: '2.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/ubuntu/') }
          end

          context 'on Ubuntu 12.04 and Zabbix 2.2' do
            let :params do
              {
                zabbix_version: '2.2',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/ubuntu/') }
          end

          context 'on Ubuntu 12.04 and Zabbix 2.4' do
            let :params do
              {
                zabbix_version: '2.4',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.4/ubuntu/') }
          end
        when '14.04'
          context 'on Ubuntu 14.04 and Zabbix 2.4' do
            let :params do
              {
                zabbix_version: '2.4',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.4/ubuntu/') }
          end

          context 'on Ubuntu 14.04 and Zabbix 3.0' do
            let :params do
              {
                zabbix_version: '3.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/3.0/ubuntu/') }
          end
        end
      when 'RedHat'

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('zabbix::params') }
        it { is_expected.to contain_class('zabbix::repo') }
        # rubocop:enable RSpec/RepeatedExample

        case facts[:os]['release']['major']
        when '5'
          context 'on RedHat 5 and Zabbix 2.0' do
            let :params do
              {
                zabbix_version: '2.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/2.0/rhel/5/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/5/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
          end
        when '6'

          context 'on RedHat 6 and Zabbix 2.0' do
            let :params do
              {
                zabbix_version: '2.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/2.0/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
          end

          context 'on RedHat 6 and Zabbix 2.2' do
            let :params do
              {
                zabbix_version: '2.2',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/2.2/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
          end

          context 'on RedHat 6 and Zabbix 2.4' do
            let :params do
              {
                zabbix_version: '2.4',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/2.4/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
          end

          context 'on RedHat 6 and Zabbix 3.0' do
            let :params do
              {
                zabbix_version: '3.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
          end

          context 'on RedHat 6 and Zabbix 3.2' do
            let :params do
              {
                zabbix_version: '3.2',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/3.2/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-79EA5ED4') }
          end
        when '7'

          context 'on RedHat 7 and Zabbix 3.0' do
            let :params do
              {
                zabbix_version: '3.0',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/3.0/rhel/7/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/7/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
          end

          context 'on RedHat 7 and Zabbix 3.2' do
            let :params do
              {
                zabbix_version: '3.2',
                manage_repo: true
              }
            end

            it { is_expected.to contain_yumrepo('zabbix').with_baseurl('https://repo.zabbix.com/zabbix/3.2/rhel/7/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('https://repo.zabbix.com/non-supported/rhel/7/$basearch/') }
            it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-79EA5ED4') }
          end
        end
      end
    end
  end
end
