require 'spec_helper_acceptance'

describe 'zabbix::agent class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'zabbix::agent':
        server => '192.168.20.11'
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
    end
  end
end
