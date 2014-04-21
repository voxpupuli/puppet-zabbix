require 'spec_helper'

describe 'zabbix::agent' do
  # Set some facts / params.
  let(:facts) {{:operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
  let(:params) { {:server => '192.168.1.1', :serveractive => '192.168.1.1', :manage_repo => true, :zabbix_version => '2.2'} }

  context "when declaring manage_repo is true" do
    let :params do
      { :manage_repo => true }
    end

    describe 'with repo' do
      let(:facts) {{:operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}

      # Make sure we have the zabbix::repo 
      it do 
        should contain_class('zabbix::repo').with({
          'zabbix_version' => '2.2',
        })
      end

      # Make sure we have 'required' the zabbix::repo module for the package.
      it do 
        should contain_package('zabbix-agent').with_require('Class[Zabbix::Repo]')
      end

    end
  end

  context "when declaring manage_repo is false" do
    let(:facts) {{:operatingsystem => 'RedHat', :operatingsystemrelease => '6.5'}}
    let :params do
      { :manage_repo => false }
    end
    describe 'without repo' do
        it { should_not contain_class('Zabbix::Repo') }
    end
  end

  # Make sure package will be installed.
  it do
    should contain_package('zabbix-agent').with({
    :ensure => :present,
    :name   => 'zabbix-agent',
  })
  end

  # We need an zabbix-agent service.
  it { should contain_service('zabbix-agent').with(
    'name'       => 'zabbix-agent',
    'ensure'     => 'running',
    'enable'     => 'true',
    'hasstatus'  => 'true',
    'hasrestart' => 'true',
    'require'    => 'Package[zabbix-agent]'
    )
  }

  # Include directory should be available.
  it { should contain_file('/etc/zabbix/zabbix_agentd.d/').with(
    'ensure'  => 'directory',
    'owner'   => 'zabbix',
    'group'   => 'zabbix',
    'recurse' => 'true',
    'purge'   => 'true',
    )
  }

  # Make sure the confifuration file is present.
  it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with(
    'ensure'  => 'present',
    'owner'   => 'zabbix',
    'group'   => 'zabbix',
    'mode'    => '0644',
    'notify'  => 'Service[zabbix-agent]',
    'require' => 'Package[zabbix-agent]',
    )
  }

  # Make sure we have set some vars in zabbix_agentd.conf file. 
  #TODO: A lot more vars has to be added. (Also for specific zabbix version?)
  it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^Server=192.168.1.1$} }
  it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content %r{^ServerActive=192.168.1.1$} }

  # So if manage_firewall is set to true, it should install
  # the firewall rule.
  context "when declaring manage_firewall is true" do
    let :params do
      { :manage_firewall => true }
    end
    describe 'with firewall' do
      it { should contain_firewall('150 zabbix-agent') }
    end
  end

  # If not, we don't want an firewall rule.
  context "when declaring manage_firewall is false" do
    let :params do
      { :manage_firewall => false }
    end
    describe 'without firewall' do
      it { should_not contain_firewall('150 zabbix-agent') }
    end
  end

end
