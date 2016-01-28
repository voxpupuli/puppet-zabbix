require 'spec_helper'

describe 'zabbix::repo' do
  # Set some facts / params.
#  let(:params) { {:manage_repo => true} }

  # Testing the Debian: 6, ZBX: 2.0
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
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

  # Testing the Debian: 7, ZBX: 2.0
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
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

  # Testing the Debian: 7, ZBX: 2.2
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.2', :manage_repo => true} }
    let :facts do
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

  # Testing the Debian: 7, ZBX: 2.4
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.4', :manage_repo => true} }
    let :facts do
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

  # Testing the Ubuntu: 12.04, ZBX: 2.0
  context "on a Ubuntu OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
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

  # Testing the Ubuntu: 12.04, ZBX: 2.2
  context "on a Ubuntu OS" do
    let(:params) { {:zabbix_version => '2.2', :manage_repo => true} }
    let :facts do
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

  # Testing the Ubuntu: 12.04, ZBX: 2.4
  context "on a Ubuntu OS" do
    let(:params) { {:zabbix_version => '2.4', :manage_repo => true} }
    let :facts do
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


  # Testing the RHEL: 5, ZBX: 2.0
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
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

  # Testing the RHEL: 6, ZBX: 2.0
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
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

  # Testing the RHEL: 6, ZBX: 2.2
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.2', :manage_repo => true} }
    let :facts do
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

  # Testing the RHEL: 6, ZBX: 2.4
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.4', :manage_repo => true} }
    let :facts do
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
