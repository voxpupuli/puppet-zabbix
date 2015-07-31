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
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian',
        :osfamily               => 'Debian'
      }
    end
    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/debian/') }
    it { should contain_apt__source('zabbix').with_release('squeeze') }
  end

  # Testing the Debian: 7, ZBX: 2.0
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian',
        :osfamily               => 'Debian'
      }
    end
    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/debian/') }
    it { should contain_apt__source('zabbix').with_release('wheezy') }
  end

  # Testing the Debian: 7, ZBX: 2.2
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.2', :manage_repo => true} }
    let :facts do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian',
        :osfamily               => 'Debian'
      }
    end
    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/debian/') }
    it { should contain_apt__source('zabbix').with_release('wheezy') }
  end

  # Testing the Ubuntu: 12.04, ZBX: 2.0
  context "on a Ubuntu OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
      {
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Ubuntu',
        :osfamily               => 'Debian'
      }
    end
    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.0/ubuntu/') }
    it { should contain_apt__source('zabbix').with_release('precise') }
  end

  # Testing the Ubuntu: 12.04, ZBX: 2.2
  context "on a Ubuntu OS" do
    let(:params) { {:zabbix_version => '2.2', :manage_repo => true} }
    let :facts do
      {
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Ubuntu',
        :osfamily               => 'Debian'
      }
    end
    it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/ubuntu/') }
    it { should contain_apt__source('zabbix').with_release('precise') }
  end

  # Testing the RHEL: 5, ZBX: 2.0
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '5',
        :architecture           => 'x86_64',
      }
    end
    it { should contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.0/rhel/5/x86_64/') }
    it { should contain_yumrepo('zabbix').with_name('Zabbix_5_x86_64') }
    it { should contain_yumrepo('zabbix').with_descr('Zabbix_5_x86_64') }

    it { should contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/5/x86_64/') }
    it { should contain_yumrepo('zabbix-nonsupported').with_name('Zabbix_nonsupported_5_x86_64') }
    it { should contain_yumrepo('zabbix-nonsupported').with_descr('Zabbix_nonsupported_5_x86_64') }
  end

  # Testing the RHEL: 6, ZBX: 2.0
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.0', :manage_repo => true} }
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :architecture           => 'x86_64',
      }
    end
    it { should contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.0/rhel/6/x86_64/') }
    it { should contain_yumrepo('zabbix').with_name('Zabbix_6_x86_64') }
    it { should contain_yumrepo('zabbix').with_descr('Zabbix_6_x86_64') }

    it { should contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/6/x86_64/') }
    it { should contain_yumrepo('zabbix-nonsupported').with_name('Zabbix_nonsupported_6_x86_64') }
    it { should contain_yumrepo('zabbix-nonsupported').with_descr('Zabbix_nonsupported_6_x86_64') }
  end

  # Testing the RHEL: 6, ZBX: 2.2
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.2', :manage_repo => true} }
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :architecture           => 'x86_64',
      }
    end
    it { should contain_yumrepo('zabbix').with_baseurl('http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/') }
    it { should contain_yumrepo('zabbix').with_name('Zabbix_6_x86_64') }
    it { should contain_yumrepo('zabbix').with_descr('Zabbix_6_x86_64') }

    it { should contain_yumrepo('zabbix-nonsupported').with_baseurl('http://repo.zabbix.com/non-supported/rhel/6/x86_64/') }
    it { should contain_yumrepo('zabbix-nonsupported').with_name('Zabbix_nonsupported_6_x86_64') }
    it { should contain_yumrepo('zabbix-nonsupported').with_descr('Zabbix_nonsupported_6_x86_64') }
  end
end
