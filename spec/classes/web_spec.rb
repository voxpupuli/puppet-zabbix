# encoding: utf-8
require 'spec_helper'

def package_provider_for_gems
  Puppet.version =~ /^4/ ? 'puppet_gem' : 'gem'
end

describe 'zabbix::web' do
  let :node do
    'rspec.puppet.com'
  end

  let :params do
    {
      zabbix_url: 'zabbix.example.com'
    }
  end

  # Running an RedHat OS.
  context 'On a RedHat OS' do
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
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
        selinux_config_mode: ''
      }
    end

    describe 'with default settings' do
      it { should contain_file('/etc/zabbix/web').with_ensure('directory') }
      it { should_not contain_selboolean('httpd_can_connect_zabbix') }
    end

    describe 'with enabled selinux' do
      let :facts do
        super().merge(selinux_config_mode: 'enforcing')
      end
      it { should contain_selboolean('httpd_can_connect_zabbix').with('value' => 'on', 'persistent' => true) }
    end

    describe 'with database_type as postgresql' do
      let :params do
        super().merge(database_type: 'postgresql')
      end

      it { should contain_package('zabbix-web-pgsql').with_name('zabbix-web-pgsql') }
      it { should contain_package('zabbix-web') }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['TYPE'\]     = 'POSTGRESQL'/) }
    end

    describe 'with database_type as mysql' do
      let :params do
        super().merge(database_type: 'mysql')
      end

      it { should contain_package('zabbix-web-mysql').with_name('zabbix-web-mysql') }
      it { should contain_package('zabbix-web') }
    end

    it { should contain_file('/etc/zabbix/web/zabbix.conf.php') }

    describe 'when manage_resources is true' do
      let :params do
        super().merge(
          manage_resources: true
        )
      end

      it { should contain_class('zabbix::resources::web') }
      it { should contain_package('zabbixapi').that_requires('Class[ruby::dev]').with_provider(package_provider_for_gems) }
      it { should contain_class('ruby::dev') }
      it { should contain_file('/etc/zabbix/imported_templates').with_ensure('directory') }
    end

    describe 'when manage_resources and is_pe are true' do
      let :facts do
        super().merge(
          is_pe: true,
          pe_version: '3.7.0'
        )
      end

      let :params do
        super().merge(manage_resources: true)
      end

      it { should contain_package('zabbixapi').with_provider('pe_puppetserver_gem') }
    end

    describe 'when manage_resources is false' do
      let :params do
        super().merge(manage_resources: false)
      end

      it { should_not contain_class('zabbix::resources::web') }
    end

    it { should contain_apache__vhost('zabbix.example.com').with_name('zabbix.example.com') }

    context 'with database_* settings' do
      let :params do
        super().merge(
          database_host: 'localhost',
          database_name: 'zabbix-server',
          database_user: 'zabbix-server',
          database_password: 'zabbix-server',
          zabbix_server: 'localhost')
      end

      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['SERVER'\]   = 'localhost'/) }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['DATABASE'\] = 'zabbix-server'/) }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['USER'\]     = 'zabbix-server'/) }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$DB\['PASSWORD'\] = 'zabbix-server'/) }
      it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(/^\$ZBX_SERVER      = 'localhost'/) }
    end
  end
end

describe 'zabbix::web' do
  let :node do
    'rspec.puppet.com'
  end

  let :params do
    {
      zabbix_url: 'zabbix.example.com'
    }
  end

  context 'On Debian 6.0' do
    let :facts do
      {
        osfamily: 'debian',
        operatingsystem: 'debian',
        operatingsystemrelease: '6.0',
        operatingsystemmajrelease: '6',
        architecture: 'x86_64',
        lsbdistid: 'debian',
        concat_basedir: '/tmp',
        is_pe: false,
        puppetversion: Puppet.version,
        facterversion: Facter.version,
        ipaddress: '192.168.1.10',
        lsbdistcodename: 'squeeze',
        id: 'root',
        kernel: 'Linux',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin',
        selinux_config_mode: ''
      }
    end

    it { should contain_package('zabbix-frontend-php') }
  end
end
