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
    # Set some vars
    host = @resource[:hostname]
    ipaddress = @resource[:ipaddress]

    # Normally 0 is active and 1 is passive, in the API, its 5 and 6
    proxy_mode = @resource[:mode] + 5

    use_ip = @resource[:use_ip]
    port = @resource[:port]

    # Check if we need to connect via ip or fqdn
    use_ip = use_ip ? 1 : 0

    zbx.proxies.create_or_update(
      host: host,
      status: proxy_mode,
      interfaces: [
        ip: ipaddress,
        dns: host,
        useip: use_ip,
        port: port
      ]
    )
  end

  def exists?
    check_proxy(@resource[:hostname])
  end

  mk_resource_methods
end
