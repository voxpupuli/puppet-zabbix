require 'spec_helper'

describe 'zabbix::repo' do
  context "on Debian 6 and Zabbix 2.0" do
    let (:params) do
      {
        :zabbix_version => '2.0',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '6',
        :lsbdistcodename        => 'squeeze',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian',
        :osfamily               => 'Debian'
      }
    end

    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/debian/') }
  end

  context "on Debian 7 and Zabbix 2.0" do
    let (:params) do
      {
        :zabbix_version => '2.0',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7',
        :lsbdistcodename        => 'wheezy',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian',
        :osfamily               => 'Debian'
      }
    end

    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/debian/') }
  end

  context "on Debian 7 and Zabbix 2.2" do
    let (:params) do
      {
        :zabbix_version => '2.2',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7',
        :lsbdistcodename        => 'wheezy',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian',
        :osfamily               => 'Debian'
      }
    end

    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/debian/') }
  end

  context "on Debian 7 and Zabbix 2.4" do
    let (:params) do
      {
        :zabbix_version => '2.4',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7',
        :lsbdistcodename        => 'wheezy',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian',
        :osfamily               => 'Debian'
      }
    end

    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.4/debian/') }
  end

  context "on Ubuntu 12.04 and Zabbix 2.0" do
    let (:params) do
      {
        :zabbix_version => '2.0',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :lsbdistcodename        => 'Precise',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Ubuntu',
        :osfamily               => 'Debian'
      }
    end

    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/ubuntu/') }
  end

  context "on Ubuntu 12.04 and Zabbix 2.2" do
    let (:params) do
      {
        :zabbix_version => '2.2',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :lsbdistcodename        => 'Precise',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Ubuntu',
        :osfamily               => 'Debian'
      }
    end

    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/ubuntu/') }
  end

  context "on Ubuntu 12.04 and Zabbix 2.4" do
    let (:params) do
      {
        :zabbix_version => '2.4',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :lsbdistcodename        => 'Precise',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Ubuntu',
        :osfamily               => 'Debian'
      }
    end

    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.4/ubuntu/') }
  end


  context "on RedHat 5 and Zabbix 2.0" do
    let (:params) do
      {
        :zabbix_version => '2.0',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '5',
        :architecture           => 'x86_64',
        :osfamily               => 'RedHat'
      }
    end

    it { should contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.0/rhel/$releasever/$basearch/') }
    it { should contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/$releasever/$basearch/') }
  end

  context "on RedHat 6 and Zabbix 2.0" do
    let (:params) do
      {
        :zabbix_version => '2.0',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :architecture           => 'x86_64',
        :osfamily               => 'RedHat',
        :$majorrelease          => '6'
      }
    end

    it { should contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.0/rhel/$releasever/$basearch/') }
    it { should contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/$releasever/$basearch/') }
  end

  context "on RedHat 6 and Zabbix 2.2" do
    let (:params) do
      {
        :zabbix_version => '2.2',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :architecture           => 'x86_64',
        :osfamily               => 'RedHat',
        :$majorrelease          => '6'
      }
    end

    it { should contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.2/rhel/$releasever/$basearch/') }
    it { should contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/$releasever/$basearch/') }
  end

  context "on RedHat 6 and Zabbix 2.4" do
    let (:params) do
      {
        :zabbix_version => '2.4',
        :manage_repo => true,
      }
    end

    let (:facts) do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :architecture           => 'x86_64',
        :osfamily               => 'RedHat',
        :$majorrelease          => '6'
      }
    end

    it { should contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.4/rhel/$releasever/$basearch/') }
    it { should contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/$releasever/$basearch/') }
  end
end
