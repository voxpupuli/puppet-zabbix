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
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts.merge(
          concat_basedir: '/tmp',
        )
      end

      let :params do
        super().merge(manage_resources: true)
      end

        describe 'with enforcing selinux' do
          let :facts do
            super().merge(selinux_config_mode: 'enforcing')
          end
          if facts[:osfamily] == 'RedHat'
            it { should contain_selboolean('httpd_can_connect_zabbix').with('value' => 'on', 'persistent' => true) }
          else
            it { should_not contain_selboolean('httpd_can_connect_zabbix') }
          end
        end

        ['permissive', 'disabled'].each do |mode|
          describe "with #{mode} selinux" do
            let :facts do
              super().merge(selinux_config_mode: mode)
            end
            it { should_not contain_selboolean('httpd_can_connect_zabbix') }
          end
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
          zabbix_server: 'localhost'
        )
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
