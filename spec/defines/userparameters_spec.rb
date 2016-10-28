require 'spec_helper'

describe 'zabbix::userparameters', type: :define do
  let :facts do
    {
      osfamily: 'RedHat',
      operatingsystem: 'RedHat',
      operatingsystemrelease: '6.5',
      operatingsystemmajrelease: '6',
      architecture: 'x86_64',
      lsbdistid: 'RedHat',
      concat_basedir: '/tmp',
      is_pe: false,
      puppetversion: Puppet.version,
      facterversion: Facter.version,
      ipaddress: '192.168.1.10',
      lsbdistcodename: '',
      id: 'root',
      kernel: 'Linux',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
      systemd: false
    }
  end
  let(:title) { 'mysqld' }
  let(:pre_condition) { 'class { "zabbix::agent": include_dir => "/etc/zabbix/zabbix_agentd.d" }' }

  context 'with an content' do
    let(:params) { { content: 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive' } }
    it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_ensure('present') }
    it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_content %r{^UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive$} }
    it { is_expected.to contain_class('zabbix::params') }
    it { is_expected.to contain_class('zabbix::repo') }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/init.d/zabbix-agent') }
    it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf') }
    it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d') }
    it { is_expected.to contain_package('zabbix-agent') }
    it { is_expected.to contain_service('zabbix-agent') }
    it { is_expected.to contain_yumrepo('zabbix-nonsupported') }
    it { is_expected.to contain_yumrepo('zabbix') }
    it { is_expected.to contain_zabbix__startup('zabbix-agent') }
  end
end
