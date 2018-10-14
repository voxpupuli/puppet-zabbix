require 'spec_helper_acceptance'

['2.4', '3.2', '3.4', '4.0'].each do |version|
  if version == '2.4' && default[:platform] =~ %r{(ubuntu-16.04-amd64|debian-8-amd64)}
    next
  end
  describe 'zabbix::agent class' do
    context "default parameters and zabbix version #{version}" do
      # Using puppet_apply as a helper
      it 'works idempotently with no errors' do
        pp = <<-EOS
        class { 'zabbix::agent':
          server               => '192.168.20.11',
          zabbix_package_state => 'latest',
          zabbix_version       => '#{version}'
        }
        EOS

        # Run it twice and test for idempotency
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end

      # do some basic checks
      describe package('zabbix-agent') do
        it { is_expected.to be_installed }
      end

      describe service('zabbix-agent') do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end

      describe file('/etc/zabbix/zabbix_agentd.conf') do
        its(:content) { is_expected.not_to match %r{ListenIP=} }
      end
    end
  end
end

describe 'zabbix::agent class' do
  context 'With ListenIP set to an IP-Address' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'zabbix::agent':
        server               => '192.168.20.11',
        zabbix_package_state => 'latest',
        listenip             => '127.0.0.1',
        zabbix_version       => '3.4'
      }
      EOS
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
    describe file('/etc/zabbix/zabbix_agentd.conf') do
      its(:content) { is_expected.to match %r{ListenIP=127.0.0.1} }
    end
  end
  context 'With ListenIP set to lo' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'zabbix::agent':
        server               => '192.168.20.11',
        zabbix_package_state => 'latest',
        listenip             => 'lo',
        zabbix_version       => '3.4'
      }
      EOS
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
    describe file('/etc/zabbix/zabbix_agentd.conf') do
      its(:content) { is_expected.to match %r{ListenIP=127.0.0.1} }
    end
  end
end
