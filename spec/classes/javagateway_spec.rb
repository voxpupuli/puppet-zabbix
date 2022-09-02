# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix::javagateway' do
  let :node do
    'rspec.puppet.com'
  end

  on_supported_os(baseline_os_hash).each do |os, facts|
    next if facts[:os]['name'] == 'windows'

    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with all defaults' do
        it { is_expected.to contain_file('/etc/zabbix/zabbix_java_gateway.conf') }
        it { is_expected.to contain_service('zabbix-java-gateway') }
        it { is_expected.to contain_package('zabbix-java-gateway') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('zabbix::javagateway') }
        it { is_expected.to contain_class('zabbix::params') }

        it { is_expected.to contain_service('zabbix-java-gateway').with_ensure('running') }
        it { is_expected.to contain_service('zabbix-java-gateway').with_enable('true') }
        it { is_expected.to contain_service('zabbix-java-gateway').with_require(['Package[zabbix-java-gateway]', 'File[/etc/zabbix/zabbix_java_gateway.conf]']) }
      end

      context 'when declaring manage_repo is true' do
        let :params do
          {
            manage_repo: true
          }
        end

        case facts[:osfamily]
        when 'Archlinux'
          it { is_expected.not_to compile }
        when 'RedHat'
          # rubocop:disable RSpec/RepeatedExample
          it { is_expected.to contain_yumrepo('zabbix-nonsupported') }
          it { is_expected.to contain_yumrepo('zabbix') }
          it { is_expected.to contain_class('Zabbix::Repo') }
        when 'Debian'
          it { is_expected.to contain_apt__source('zabbix') }
          it { is_expected.to contain_class('Zabbix::Repo') }
          it { is_expected.to contain_class('apt') }
          # rubocop:enable RSpec/RepeatedExample
        end
      end

      context 'when declaring manage_firewall is true' do
        let(:params) do
          {
            manage_firewall: true
          }
        end

        it { is_expected.to contain_firewall('152 zabbix-javagateway') }
      end

      context 'when declaring manage_firewall is false' do
        let(:params) do
          {
            manage_firewall: false
          }
        end

        it { is_expected.not_to contain_firewall('152 zabbix-javagateway') }
      end

      context 'with zabbix_java_gateway.conf settings' do
        let(:params) do
          {
            listenip: '192.168.1.1',
            listenport: '10052',
            pidfile: '/var/run/zabbix/zabbix_java.pid',
            startpollers: '5',
            timeout: '15'
          }
        end

        it { is_expected.to contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^LISTEN_IP=192.168.1.1$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^LISTEN_PORT=10052$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^PID_FILE=/var/run/zabbix/zabbix_java.pid$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^START_POLLERS=5$} }
        it { is_expected.to contain_file('/etc/zabbix/zabbix_java_gateway.conf').with_content %r{^TIMEOUT=15$} }
      end
    end
  end
end
