require 'spec_helper'

describe 'zabbix::userparameters', :type => :define do
  let :facts do
    {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '6.5',
      :architecture           => 'x86_64',
      :lsbdistid              => 'RedHat',
      :concat_basedir         => '/tmp'
    }
  end
  let(:title) { 'mysqld' }
  let(:pre_condition)  { 'class { "zabbix::agent": include_dir => "/etc/zabbix/zabbix_agentd.d" }' }
  
  context "with an content" do
    let(:params) {{ :content => 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive' } }
    it { should contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_ensure('present') }
    it { should contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_content %r{^UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive$}}
  end

end
