# frozen_string_literal: true

require 'spec_helper_acceptance'
describe 'zabbix::proxy class', unless: default[:platform] =~ %r{archlinux} do
  before(:all) do
    prepare_host
  end

  context 'default parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'zabbix::proxy':
          zabbix_server_host => '192.168.1.1',
        }
        PUPPET
      end
    end

    # do some basic checks
    describe package('zabbix-proxy-pgsql') do
      it { is_expected.to be_installed }
    end

    describe service('zabbix-proxy') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  supported_proxy_versions(default[:platform]).each do |zabbix_version|
    context "deploys a zabbix #{zabbix_version} proxy" do
      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-PUPPET
          class { 'zabbix::proxy':
            zabbix_server_host => '192.168.1.1',
            zabbix_version => "#{zabbix_version}",
          }
          PUPPET
        end
      end

      # do some basic checks
      describe package('zabbix-proxy-pgsql') do
        it { is_expected.to be_installed }
      end

      describe service('zabbix-proxy') do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end
    end
  end
end
