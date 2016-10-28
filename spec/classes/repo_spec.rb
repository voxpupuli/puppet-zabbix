require 'spec_helper'

describe 'zabbix::repo' do
  context 'on Debian 6 and Zabbix 2.0' do
    let :params do
      {
        zabbix_version: '2.0',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'Debian',
        operatingsystemrelease: '6',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64',
        lsbdistid: 'Debian',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'squeeze',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/debian/') }
  end

  context 'on Debian 7 and Zabbix 2.0' do
    let :params do
      {
        zabbix_version: '2.0',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'Debian',
        operatingsystemrelease: '7',
        operatingsystemmajrelease: '7',
        architecture: 'x86_64',
        lsbdistid: 'Debian',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'wheezy',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
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

    let :facts do
      {
        operatingsystem: 'Debian',
        operatingsystemrelease: '7',
        operatingsystemmajrelease: '7',
        architecture: 'x86_64',
        lsbdistid: 'Debian',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'wheezy',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
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

    let :facts do
      {
        operatingsystem: 'Debian',
        operatingsystemrelease: '7',
        operatingsystemmajrelease: '7',
        architecture: 'x86_64',
        lsbdistid: 'Debian',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'wheezy',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.4/debian/') }
  end

  context 'on Debian 8 and Zabbix 3.0' do
    let :params do
      {
        zabbix_version: '3.0',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'Debian',
        operatingsystemrelease: '8',
        operatingsystemmajrelease: '8',
        architecture: 'x86_64',
        lsbdistid: 'Debian',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'jessie',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/3.0/debian/') }
  end

  context 'on Ubuntu 12.04 and Zabbix 2.0' do
    let :params do
      {
        zabbix_version: '2.0',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '12.04',
        operatingsystemmajrelease: '12',
        architecture: 'x86_64',
        lsbdistid: 'Ubuntu',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'Precise',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
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

    let :facts do
      {
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '12.04',
        operatingsystemmajrelease: '12',
        architecture: 'x86_64',
        lsbdistid: 'Ubuntu',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'Precise',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
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

    let :facts do
      {
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '12.04',
        operatingsystemmajrelease: '12',
        architecture: 'x86_64',
        lsbdistid: 'Ubuntu',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'Precise',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.4/ubuntu/') }
  end

  context 'on Ubuntu 14.04 and Zabbix 2.4' do
    let :params do
      {
        zabbix_version: '2.4',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '14.04',
        operatingsystemmajrelease: '14',
        architecture: 'x86_64',
        lsbdistid: 'Ubuntu',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'Trusty',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
        lsbdistrelease: '14.04'
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

    let :facts do
      {
        operatingsystem: 'Ubuntu',
        operatingsystemrelease: '14.04',
        operatingsystemmajrelease: '14',
        architecture: 'x86_64',
        lsbdistid: 'Ubuntu',
        osfamily: 'Debian',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'Trusty',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
        lsbdistrelease: '14.04'
      }
    end

    it { is_expected.to contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/3.0/ubuntu/') }
  end

  context 'on RedHat 5 and Zabbix 2.0' do
    let :params do
      {
        zabbix_version: '2.0',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'RedHat',
        operatingsystemrelease: '5',
        operatingsystemmajrelease: '5',
        architecture: 'x86_64',
        osfamily: 'RedHat',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: '',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.0/rhel/5/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/5/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
  end

  context 'on RedHat 6 and Zabbix 2.0' do
    let :params do
      {
        zabbix_version: '2.0',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'RedHat',
        operatingsystemrelease: '6',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64',
        osfamily: 'RedHat',
        majorrelease: '6',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: '',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.0/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
  end

  context 'on RedHat 6 and Zabbix 2.2' do
    let :params do
      {
        zabbix_version: '2.2',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'RedHat',
        operatingsystemrelease: '6',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64',
        osfamily: 'RedHat',
        majorrelease: '6',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: '',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.2/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
  end

  context 'on RedHat 6 and Zabbix 2.4' do
    let :params do
      {
        zabbix_version: '2.4',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'RedHat',
        operatingsystemrelease: '6',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64',
        osfamily: 'RedHat',
        majorrelease: '6',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: '',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.4/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
  end

  context 'on RedHat 6 and Zabbix 3.0' do
    let :params do
      {
        zabbix_version: '3.0',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'RedHat',
        operatingsystemrelease: '6',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64',
        osfamily: 'RedHat',
        majorrelease: '6',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: '',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/3.0/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
  end

  context 'on RedHat 6 and Zabbix 3.2' do
    let :params do
      {
        zabbix_version: '3.2',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'RedHat',
        operatingsystemrelease: '6',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64',
        osfamily: 'RedHat',
        majorrelease: '6',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: '',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/3.2/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/6/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') }
  end

  context 'on RedHat 7 and Zabbix 3.0' do
    let :params do
      {
        zabbix_version: '3.0',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'RedHat',
        operatingsystemrelease: '7.1',
        operatingsystemmajrelease: '7',
        architecture: 'x86_64',
        osfamily: 'RedHat',
        majorrelease: '7',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: '',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/3.0/rhel/7/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/7/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX') }
  end

  context 'on RedHat 7 and Zabbix 3.2' do
    let :params do
      {
        zabbix_version: '3.2',
        manage_repo: true
      }
    end

    let :facts do
      {
        operatingsystem: 'RedHat',
        operatingsystemrelease: '7.1',
        operatingsystemmajrelease: '7',
        architecture: 'x86_64',
        osfamily: 'RedHat',
        majorrelease: '7',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: '',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/3.2/rhel/7/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/7/$basearch/') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported').with_gpgkey('http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-A14FE591') }
  end
end
