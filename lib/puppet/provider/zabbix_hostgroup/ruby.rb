require_relative '../zabbix'
Puppet::Type.type(:zabbix_hostgroup).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :zabbixapi

  def self.instances
    api_hostgroups = zbx.hostgroups.all
    api_hostgroups.map do |group_name, _id|
      new(
        ensure: :present,
        name: group_name
      )
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if (resource = resources[prov.name])
        resource.provider = prov
      end
    end
  end

  def create
    # Connect to zabbix api
    hgid = zbx.hostgroups.create(name: @resource[:name])
    hgid
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    zbx.hostgroups.delete(zbx.hostgroups.get_id(name: @resource[:name]))
  end
end
