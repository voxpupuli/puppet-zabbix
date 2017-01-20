require 'spec_helper'

describe 'zabbix::javagateway' do
  let :node do
    'rspec.puppet.com'
  end

  context 'On RedHat 6.5' do
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
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    it { is_expected.to contain_file('/etc/zabbix/zabbix_java_gateway.conf') }
    it { is_expected.to contain_service('zabbix-java-gateway') }
    it { is_expected.to contain_package('zabbix-java-gateway') }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_class('zabbix::javagateway') }
    it { is_expected.to contain_class('zabbix::params') }
    context 'when declaring manage_repo is true' do
      let :params do
        {
          manage_repo: true
        }
      end

      it { is_expected.to contain_class('Zabbix::Repo') }
      it { is_expected.to contain_yumrepo('zabbix-nonsupported') }
      it { is_expected.to contain_yumrepo('zabbix') }
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
