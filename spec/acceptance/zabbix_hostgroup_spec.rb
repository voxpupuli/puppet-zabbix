# frozen_string_literal: true

require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

describe 'zabbix_hostgroup type', unless: default[:platform] =~ %r{archlinux} do
  supported_versions.each do |zabbix_version|
    # >= 5.2 server packages are not available for RHEL 7
    next if zabbix_version >= '5.2' && default[:platform] == 'el-7-x86_64'
    # < 6.0 server packages are not available for RHEL 9
    next if zabbix_version < '6.0' && default[:platform] == 'el-9-x86_64'
    # <6.0 server packages are not available for ubuntu 22.04
    next if zabbix_version < '6.0' && default[:platform] =~ %r{ubuntu-22}
    # < 6.0 server packages are not available for Debian 12
    next if zabbix_version < '6.0' && default[:platform] =~ %r{debian-12}

    context "create zabbix_hostgroup resources with zabbix version #{zabbix_version}" do
      # This will deploy a running Zabbix setup (server, web, db) which we can
      # use for custom type tests
      pp1 = <<-EOS
        class { 'zabbix':
          zabbix_version   => "#{zabbix_version}",
          zabbix_url       => 'localhost',
          zabbix_api_user  => 'Admin',
          zabbix_api_pass  => 'zabbix',
          apache_use_ssl   => false,
          manage_resources => true,
        }
      EOS

      pp2 = <<-EOS
        Zabbix_hostgroup { }

        zabbix_hostgroup { 'Testgroup2': }
        zabbix_hostgroup { 'Linux servers':
          ensure => absent,
        }
      EOS

      # setup zabbix. Apache module isn't idempotent and requires a second run
      it 'works with no error on the first apply' do
        # Cleanup old database
        prepare_host

        apply_manifest(pp1, catch_failures: true)
      end

      it 'works with no error on the second apply' do
        apply_manifest(pp1, catch_failures: true)
      end

      it 'works with no error on the third apply' do
        apply_manifest(pp2, catch_failures: true)
      end
    end

    let(:result_hostgroups) do
      zabbixapi('localhost', 'Admin', 'zabbix', 'hostgroup.get', output: 'extend').result
    end

    context 'Testgroup2' do
      it 'is created' do
        expect(result_hostgroups.map { |t| t['name'] }).to include('Testgroup2')
      end
    end

    context 'Linux servers' do
      it 'is absent' do
        expect(result_hostgroups.map { |t| t['name'] }).not_to include('Linux servers')
      end
    end
  end
end
