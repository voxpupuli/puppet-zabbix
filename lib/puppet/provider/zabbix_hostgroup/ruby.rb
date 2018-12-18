require_relative '../zabbix'
Puppet::Type.type(:zabbix_hostgroup).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :zabbixapi

  def create
    # Connect to zabbix api
    hgid = zbx.hostgroups.create(name: @resource[:name])
    hgid
  end

  def exists?
    zbx.hostgroups.get_id(name: @resource[:name])
  end

  def destroy
    zbx.hostgroups.delete(zbx.hostgroups.get_id(name: @resource[:name]))
  end
end
