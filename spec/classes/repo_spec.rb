require 'spec_helper'

describe 'zabbix::repo' do
  # Set some facts / params.
  
  # Testing the Deviab: 6, ZBX: 2.0
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.0'} }
    let :facts do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '6',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian'
      }
    end
    it { should contain_apt__source('zabbix').with(
      'location'   => 'http://repo.zabbix.com/zabbix/2.0/debian/',
      'release'    => 'squeeze',
      'repos'      => 'main',
      'key'        => '79EA5ED4',
      'key_source' => 'http://repo.zabbix.com/zabbix-official-repo.key',
    ) }
  end

  # Testing the Deviab: 7, ZBX: 2.0
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.0'} }
    let :facts do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian'
      }
    end
    it { should contain_apt__source('zabbix').with(
      'location'   => 'http://repo.zabbix.com/zabbix/2.0/debian/',
      'release'    => 'wheezy',
      'repos'      => 'main',
      'key'        => '79EA5ED4',
      'key_source' => 'http://repo.zabbix.com/zabbix-official-repo.key',
    ) }
  end

  # Testing the Deviab: 7, ZBX: 2.2
  context "on a Debian OS" do
    let(:params) { {:zabbix_version => '2.2'} }
    let :facts do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '7',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Debian'
      }
    end
    it { should contain_apt__source('zabbix').with(
      'location'   => 'http://repo.zabbix.com/zabbix/2.2/debian/',
      'release'    => 'wheezy',
      'repos'      => 'main',
      'key'        => '79EA5ED4',
      'key_source' => 'http://repo.zabbix.com/zabbix-official-repo.key',
    ) }
  end



  # Testing the Ubuntu: 12.04, ZBX: 2.0
  context "on a Ubuntu OS" do
    let(:params) { {:zabbix_version => '2.0'} }
    let :facts do
      {
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Ubuntu'
      }
    end
    it { should contain_apt__source('zabbix').with(
      'location'   => 'http://repo.zabbix.com/zabbix/2.0/ubuntu/',
      'release'    => 'precise',
      'repos'      => 'main',
      'key'        => '79EA5ED4',
      'key_source' => 'http://repo.zabbix.com/zabbix-official-repo.key',
    ) }
  end

  # Testing the Ubuntu: 12.04, ZBX: 2.2
  context "on a Ubuntu OS" do
    let(:params) { {:zabbix_version => '2.2'} }
    let :facts do
      {
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :architecture           => 'x86_64',
        :lsbdistid              => 'Ubuntu'
      }
    end
    it { should contain_apt__source('zabbix').with(
      'location'   => 'http://repo.zabbix.com/zabbix/2.2/ubuntu/',
      'release'    => 'precise',
      'repos'      => 'main',
      'key'        => '79EA5ED4',
      'key_source' => 'http://repo.zabbix.com/zabbix-official-repo.key',
    ) }
  end

  # Testing the RHEL: 5, ZBX: 2.0
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.0'} }
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '5',
        :architecture           => 'x86_64',
      }
    end
    it { should contain_yumrepo('zabbix').with(
      'name'     => 'Zabbix_5_x86_64',
      'descr'    => 'Zabbix_5_x86_64',
      'baseurl'  => 'http://repo.zabbix.com/zabbix/2.0/rhel/5/x86_64/',
      'gpgcheck' => '1',
      'gpgkey'   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
      'priority' => '1',
    ) }
    it { should contain_yumrepo('zabbix-nonsupported').with(
      'name'     => 'Zabbix_nonsupported_5_x86_64',
      'descr'    => 'Zabbix_nonsupported_5_x86_64',
      'baseurl'  => 'http://repo.zabbix.com/non-supported/rhel/5/x86_64/',
      'gpgcheck' => '1',
      'gpgkey'   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
      'priority' => '1',
    ) }
  end

  # Testing the RHEL: 6, ZBX: 2.0
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.0'} }
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :architecture           => 'x86_64',
      }
    end
    it { should contain_yumrepo('zabbix').with(
      'name'     => 'Zabbix_6_x86_64',
      'descr'    => 'Zabbix_6_x86_64',
      'baseurl'  => 'http://repo.zabbix.com/zabbix/2.0/rhel/6/x86_64/',
      'gpgcheck' => '1',
      'gpgkey'   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
      'priority' => '1',
    ) }
    it { should contain_yumrepo('zabbix-nonsupported').with(
      'name'     => 'Zabbix_nonsupported_6_x86_64',
      'descr'    => 'Zabbix_nonsupported_6_x86_64',
      'baseurl'  => 'http://repo.zabbix.com/non-supported/rhel/6/x86_64/',
      'gpgcheck' => '1',
      'gpgkey'   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
      'priority' => '1',
    ) }
  end

  # Testing the RHEL: 6, ZBX: 2.2
  context "on a RedHat OS" do
    let(:params) { {:zabbix_version => '2.2'} }
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :architecture           => 'x86_64',
      }
    end
    it { should contain_yumrepo('zabbix').with(
      'name'     => 'Zabbix_6_x86_64',
      'descr'    => 'Zabbix_6_x86_64',
      'baseurl'  => 'http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/',
      'gpgcheck' => '1',
      'gpgkey'   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
      'priority' => '1',
    ) }
    it { should contain_yumrepo('zabbix-nonsupported').with(
      'name'     => 'Zabbix_nonsupported_6_x86_64',
      'descr'    => 'Zabbix_nonsupported_6_x86_64',
      'baseurl'  => 'http://repo.zabbix.com/non-supported/rhel/6/x86_64/',
      'gpgcheck' => '1',
      'gpgkey'   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
      'priority' => '1',
    ) }
  end


end