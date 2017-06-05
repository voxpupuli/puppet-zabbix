require 'spec_helper_acceptance'

['2.4', '3.2'].each do |version|
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
    end
  end
end
