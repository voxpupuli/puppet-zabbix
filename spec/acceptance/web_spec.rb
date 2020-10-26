require 'spec_helper_acceptance'

def frontend_supported(version)
  return version != ('2.4'||'5.0') if default[:platform] =~ %r{(ubuntu-16.04|debian-9)-amd64}
  return version >= '4.0' if default[:platform] =~ %r{debian-10-amd64}
  true
end

['2.4', '3.2', '3.4', '4.0', '4.2', '4.4', '5.0'].each do |version|
  describe "zabbix::web class with zabbix_version #{version}", if: frontend_supported(version) do
    case fact('os.family')
    when 'RedHat'
      apache_package = 'httpd'
      apache_service = 'httpd'
    when 'Debian'
      apache_package = 'apache2'
      apache_service = 'apache2'
    end

    it 'works idempotently with no errors' do

      pp = <<-EOS
        class { 'apache':
          mpm_module => 'prefork',
        }
        include apache::mod::php
        class { 'zabbix::web':
          zabbix_version => '#{version}',
          require        => Class['apache'],
        }
      EOS

      prepare_host

      # Works without changes on the third apply
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    # do some basic checks
    describe 'ensure packages installed' do

      it { is_expected.to contain_package(apache_package) }

      pgsqlpackage = case fact('operatingsystem')
      when 'Ubuntu'
        if fact('os.release.major') >= '16.04'
          'php-pgsql'
        else
          'php5-pgsql'
        end
      when 'Debian'
        if fact('os.release.major').to_i >= 9
          'php-pgsql'
        else
          'php5-pgsql'
        end
      else
        'php5-pgsql'
      end

      if default[:platform] =~ %r{el-7-amd64}
        if :version == '5.0'
          packages = ['zabbix-web-pgsql-scl', 'zabbix-web']
        else
          packages = ['zabbix-web-pgsql', 'zabbix-web']
        end
      else
          packages = ['zabbix-frontend-php', pgsqlpackage]
      end
      packages.each do |package|
        it { is_expected.to contain_package(package) }
      end
    end

    describe service(apache_service) do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    context 'Zabbix frontend should be running on port 80 with an appropriate php handler' do

      describe port(80) do
        it { should be_listening }
      end

      #if this comes back as <?php, the php handler for the frontend is not configured correctly
      describe command('curl http://localhost:80') do
        its(:stdout) { should match /!DOCTYPE html/ }
      end
    end

  end
end
