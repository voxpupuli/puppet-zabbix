# encoding: utf-8
require 'spec_helper'

describe 'zabbix::sender' do
  let :node do
    'agent.example.com'
  end

  context 'On RedHat 7.1' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystem: 'RedHat',
        operatingsystemrelease: '7.1',
        operatingsystemmajrelease: '7',
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
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin'
      }
    end

    # Make sure package will be installed, service running and ensure of directory.
    it { should contain_package('zabbix-sender').with_ensure('present') }
    it { should contain_package('zabbix-sender').with_name('zabbix-sender') }

    context 'when declaring manage_repo is true' do
      let :params do
        {
          manage_repo: true
        }
      end

      it { should contain_class('zabbix::repo').with_zabbix_version('3.0') }
      it { should contain_package('zabbix-sender').with_require('Class[Zabbix::Repo]') }
    end
  end
end
