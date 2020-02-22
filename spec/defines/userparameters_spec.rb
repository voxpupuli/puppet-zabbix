require 'spec_helper'

describe 'zabbix::userparameters', type: :define do
  on_supported_os.each do |os, facts|
    next if facts[:os]['name'] == 'windows'
    context "on #{os} " do
      let :facts do
        systemd_fact = case facts[:os]['family']
                       when 'Archlinux', 'Fedora', 'Gentoo'
                         { systemd: true }
                       else
                         { systemd: false }
                       end
        facts.merge(systemd_fact)
      end
      let(:title) { 'mysqld' }
      let(:pre_condition) { 'class { "zabbix::agent": include_dir => "/etc/zabbix/zabbix_agentd.d" }' }

      package = facts[:osfamily] == 'Gentoo' ? 'zabbix' : 'zabbix-agent'
      service = facts[:osfamily] == 'Gentoo' ? 'zabbix-agentd' : 'zabbix-agent'

      context 'with an content' do
        let(:params) { { content: 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive' } }

        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_ensure('present') }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_content %r{^UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive$} }
        it { is_expected.to contain_class('zabbix::params') }
        it { is_expected.to contain_class('zabbix::repo') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file("/etc/init.d/#{service}") }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf') }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d') }
        it { is_expected.to contain_package(package) }
        it { is_expected.to contain_service(service) }
        it { is_expected.to contain_zabbix__startup(service) }
      end

      context 'with ensure => absent' do
        let(:params) { { ensure: 'absent', content: 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive' } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_ensure('absent') }
      end
    end
  end
end
