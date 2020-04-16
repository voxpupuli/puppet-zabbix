require_relative '../zabbix'
Puppet::Type.type(:zabbix_proxy).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :zabbixapi

  def self.instances
    proxies = zbx.query(
      method: 'proxy.get',
      params: {
        output: 'extend',
        selectInterface: %w[interfaceid type main ip port useip]
      }
    )

    proxies.map do |p|
      # p['interface'] is an Array if the host is a active proxy
      # p['interface'] is a Hash if the host is a passive proxy
      new(
        ensure: :present,
        id: p['proxyid'].to_i,
        name: p['host'],
        ipaddress: p['interface'].is_a?(Hash) ? p['interface']['ip'] : nil,
        use_ip: p['interface'].is_a?(Hash) ? p['interface']['use_ip'] : nil,
        mode: p['status'].to_i - 5,
        port: p['interface'].is_a?(Hash) ? p['interface']['port'] : nil
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
    @property_hash[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    @property_hash[:ensure] = :absent
  end

  def flush
    if @property_hash[:ensure] == :present
      puts @property_hash[:ensure]
      zbx.proxies.create_or_update(
        host: @resource[:hostname],
        status: @resource[:mode] + 5, # Normally 0 is active and 1 is passive, in the API, its 5 and 6
        interface: {
          ip: @resource[:ipaddress],
          dns: @resource[:hostname],
          useip: @resource[:use_ip] ? 1 : 0,
          port: @resource[:port]
        }
      )
    else
      zbx.proxies.delete([zbx.proxies.get_id(host: @resource[:hostname])].flatten)
    end
  end

  mk_resource_methods
end
