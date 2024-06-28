# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix::userparameters', type: :define do
  on_supported_os.each do |os, facts|
    next if facts[:os]['name'] == 'windows'

    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'mysqld' }
      let(:pre_condition) do
        'class { "zabbix::agent":
          include_dir => "/etc/zabbix/zabbix_agentd.d",
          agent_configfile_path => "/etc/zabbix/zabbix_agentd.conf"
        }'
      end

      case facts[:os]['family']
      when 'Gentoo'
        package_name = 'zabbix'
        service_name = 'zabbix-agentd'
      when 'FreeBSD'
        package_name = 'zabbix6-agent'
        service_name = 'zabbix_agentd'
      else
        package_name = 'zabbix-agent'
        service_name = 'zabbix-agent'
      end

      context 'with an content' do
        let(:params) { { content: 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive' } }

        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_ensure('present') }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_content %r{^UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive$} }
        it { is_expected.to contain_class('zabbix::params') }
        it { is_expected.to contain_class('zabbix::repo') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_file("/etc/init.d/#{service_name}") }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.conf') }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d') }
        it { is_expected.to contain_package(package_name) }
        it { is_expected.to contain_service(service_name) }
        it { is_expected.not_to contain_zabbix__startup(service_name) }
      end

      context 'with ensure => absent' do
        let(:params) { { ensure: 'absent', content: 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive' } }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('/etc/zabbix/zabbix_agentd.d/mysqld.conf').with_ensure('absent') }
      end
    end
  end
end
