# encoding: utf-8
require 'spec_helper'

describe 'zabbix::userparameter' do
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
    it { should compile }
  end
end
