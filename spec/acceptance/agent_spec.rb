# frozen_string_literal: true

require 'spec_helper_acceptance'

supported_versions.each do |version|
  # < 6.0 agent packages are not available for Debian 12
  next if version < '6.0' && default[:platform] =~ %r{debian-12}

  describe "zabbix::agent class with zabbix_version #{version}" do
    context 'With minimal parameter' do
      it 'works idempotently with no errors' do
        pp = <<-EOS
        class { 'zabbix::agent':
          server               => '192.168.20.11',
          zabbix_package_state => 'latest',
          zabbix_version       => '#{version}',
        }
        EOS

        prepare_host

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

    context 'With ListenIP set to an IP-Address' do
      it 'works idempotently with no errors' do
        pp = <<-EOS
          class { 'zabbix::agent':
            server               => '192.168.20.11',
            zabbix_package_state => 'latest',
            listenip             => '127.0.0.1',
            zabbix_version       => '#{version}',
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
            zabbix_version       => '#{version}',
          }
        EOS
        apply_manifest(pp, catch_failures: true)
        apply_manifest(pp, catch_changes: true)
      end

      context 'With ListenIP set to an IP-Address' do
        it 'works idempotently with no errors' do
          pp = <<-EOS
            class { 'zabbix::agent':
              server               => '192.168.20.11',
              zabbix_package_state => 'latest',
              listenip             => '127.0.0.1',
              zabbix_version       => '#{version}',
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
  end

  describe "zabbix::agent class with agent2 and zabbix_version #{version}" do
    # <6.0 agent2 packages are not available for ubuntu 22.04
    next if version < '6.0' && default[:platform] =~ %r{ubuntu-22}

    before(:all) do
      prepare_host
    end

    context 'With minimal parameter' do
      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-PUPPET
          class { 'zabbix::agent':
            agent_configfile_path => '/etc/zabbix/zabbix_agent2.conf',
            include_dir           => '/etc/zabbix/zabbix_agent2.d',
            include_dir_purge     => false,
            zabbix_package_agent  => 'zabbix-agent2',
            servicename           => 'zabbix-agent2',
            manage_startup_script => false,
            server                => '192.168.20.11',
            zabbix_package_state  => 'latest',
            zabbix_version        => '#{version}',
          }
          PUPPET
        end
      end

      # do some basic checks
      describe package('zabbix-agent2') do
        it { is_expected.to be_installed }
      end

      describe service('zabbix-agent2') do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end

      describe file('/etc/zabbix/zabbix_agentd2.conf') do
        its(:content) { is_expected.not_to match %r{ListenIP=} }
      end
    end

    context 'With ListenIP set to an IP-Address' do
      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-PUPPET
          class { 'zabbix::agent':
            agent_configfile_path => '/etc/zabbix/zabbix_agent2.conf',
            include_dir           => '/etc/zabbix/zabbix_agent2.d',
            include_dir_purge     => false,
            zabbix_package_agent  => 'zabbix-agent2',
            servicename           => 'zabbix-agent2',
            manage_startup_script => false,
            server                => '192.168.20.11',
            zabbix_package_state  => 'latest',
            listenip              => '127.0.0.1',
            zabbix_version        => '#{version}',
          }
          PUPPET
        end
      end

      describe file('/etc/zabbix/zabbix_agent2.conf') do
        its(:content) { is_expected.to match %r{ListenIP=127.0.0.1} }
      end
    end

    context 'With ListenIP set to lo' do
      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-PUPPET
          class { 'zabbix::agent':
            agent_configfile_path => '/etc/zabbix/zabbix_agent2.conf',
            include_dir           => '/etc/zabbix/zabbix_agent2.d',
            include_dir_purge     => false,
            zabbix_package_agent  => 'zabbix-agent2',
            servicename           => 'zabbix-agent2',
            manage_startup_script => false,
            server                => '192.168.20.11',
            zabbix_package_state  => 'latest',
            listenip              => 'lo',
            zabbix_version        => '#{version}',
          }
          PUPPET
        end

        describe file('/etc/zabbix/zabbix_agent2.conf') do
          its(:content) { is_expected.to match %r{ListenIP=127.0.0.1} }
        end
      end
    end
  end
end
