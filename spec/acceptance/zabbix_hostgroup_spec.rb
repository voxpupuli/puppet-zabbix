require 'spec_helper_acceptance'
require 'serverspec_type_zabbixapi'

describe 'zabbix_hostgroup type', unless: default[:platform] =~ %r{(ubuntu-16.04|debian-9)-amd64} do
  supported_versions.each do |zabbix_version|
    # 5.2 and 5.4 server packages are not available for RHEL 7
    next if zabbix_version == '5.2' && default[:platform] == 'el-7-x86_64'
    next if zabbix_version == '5.4' && default[:platform] == 'el-7-x86_64'
    # No Zabbix 5.2 packages on Debian 11
    next if zabbix_version == '5.2' && default[:platform] == 'debian-11-amd64'
    context "create zabbix_hostgroup resources with zabbix version #{zabbix_version}" do
      # This will deploy a running Zabbix setup (server, web, db) which we can
      # use for custom type tests
      pp1 = <<-EOS
        class { 'apache':
            mpm_module => 'prefork',
        }
        include apache::mod::php
        class { 'postgresql::globals':
          locale   => 'en_US.UTF-8',
          manage_package_repo => true,
          version => '12',
        }
        -> class { 'postgresql::server': }

        class { 'zabbix':
          zabbix_version   => "#{zabbix_version}",
          zabbix_url       => 'localhost',
          zabbix_api_user  => 'Admin',
          zabbix_api_pass  => 'zabbix',
          apache_use_ssl   => false,
          manage_resources => true,
          require          => [ Class['postgresql::server'], Class['apache'], ],
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
