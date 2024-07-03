# frozen_string_literal: true

require 'spec_helper_acceptance'
describe 'zabbix::server class', unless: default[:platform] =~ %r{archlinux} do
  before(:all) do
    prepare_host
  end

  context 'default parameters' do
    it_behaves_like 'an idempotent resource' do
      # this is a minimal working example if you've a postgres server
      # running on another node. multinode testing with beaker is pain,
      # so we will deploy multiple services into one box
      # pp = <<-EOS
      # class { 'zabbix::server':
      #  manage_database => false,
      # }
      # EOS

      # this will actually deploy apache + postgres + zabbix-server + zabbix-web
      let(:manifest) do
        <<-PUPPET
        class { 'zabbix::database': }
        -> class { 'zabbix::server': }
        PUPPET
      end
    end

    # do some basic checks
    describe package('zabbix-server-pgsql') do
      it { is_expected.to be_installed }
    end

    describe service('zabbix-server') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  supported_server_versions(default[:platform]).each do |zabbix_version|
    context "deploys a zabbix #{zabbix_version} server" do
      it_behaves_like 'an idempotent resource' do
        # this is a minimal working example if you've a postgres server
        # running on another node. multinode testing with beaker is pain,
        # so we will deploy multiple services into one box
        # pp = <<-EOS
        # class { 'zabbix::server':
        #  manage_database => false,
        # }
        # EOS
        # this will actually deploy apache + postgres + zabbix-server + zabbix-web
        let(:manifest) do
          <<-PUPPET
          class { 'zabbix::database': }
          -> class { 'zabbix::server':
            zabbix_version => "#{zabbix_version}"
          }
          PUPPET
        end
      end

      # do some basic checks
      describe package('zabbix-server-pgsql') do
        it { is_expected.to be_installed }
      end

      describe service('zabbix-server') do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end
    end
  end
end
