require_relative '../zabbix'
Puppet::Type.type(:zabbix_hostgroup).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :zabbixapi

  def connect
    @zbx ||= self.class.create_connection(@resource[:zabbix_url], @resource[:zabbix_user], @resource[:zabbix_pass], @resource[:apache_use_ssl])
    @zbx
  end

  def create
    # Connect to zabbix api
    zbx = connect
    hgid = zbx.hostgroups.create(name: @resource[:name])
    hgid
  end

  def exists?
    zbx = connect
    zbx.hostgroups.get_id(name: @resource[:name])
  end

  def destroy
    zbx = connect
    zbx.hostgroups.delete(zbx.hostgroups.get_id(name: @resource[:name]))
  end
end
