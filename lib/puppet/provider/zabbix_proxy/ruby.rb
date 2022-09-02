# frozen_string_literal: true

require_relative '../zabbix'
Puppet::Type.type(:zabbix_proxy).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :zabbixapi

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  mk_resource_methods

  def self.instances
    proxies.map do |p|
      new(proxy_properties_hash(p))
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if (resource = resources[prov.name])
        resource.provider = prov
      end
    end
  end

  def self.proxies(proxyids = nil)
    zbx.query(
      method: 'proxy.get',
      params: {
        proxyids: proxyids,
        output: 'extend',
        selectInterface: %w[interfaceid type main ip port useip]
      }.compact
    )
  end

  # Convert from proxy hash returned by API into a resource properties hash
  def self.proxy_properties_hash(p)
    {
      ensure: :present,
      # Proxy object properties
      proxyid: p['proxyid'].to_i,
      name: p['host'],
      mode: status_to_mode(p['status']),
      # Proxy Interface object properties
      interfaceid: p['interface'].is_a?(Hash) ? p['interface']['interfaceid'] : nil,
      ipaddress: p['interface'].is_a?(Hash) ? p['interface']['ip'] : nil,
      use_ip: if p['interface'].is_a?(Hash) then p['interface']['useip'] == '1' ? :true : :false end,
      port: p['interface'].is_a?(Hash) ? p['interface']['port'].to_i : nil
    }
  end

  def create
    mode = @resource[:mode] || :active

    if mode == :passive
      useip = if @resource[:use_ip].nil?
                1
              else
                @resource[:use_ip] == :true ? 1 : 0
              end
      interface = {
        ip: @resource[:ipaddress] || '127.0.0.1',
        dns: @resource[:hostname],
        useip: useip,
        port: @resource[:port] || 10_051
      }
    else
      interface = nil
    end

    zbx.proxies.create(
      {
        host: @resource[:hostname],
        status: self.class.mode_to_status(mode),
        interface: interface
      }.compact
    )
    @property_flush[:created] = true
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    zbx.proxies.delete([zbx.proxies.get_id(host: @resource[:hostname])].flatten)
    @property_flush[:destroyed] = true
  end

  def flush
    update unless @property_flush[:created] || @property_flush[:destroyed]

    # Update @property_hash so that the output of puppet resource is correct
    if @property_flush[:destroyed]
      @property_hash.clear
      @property_hash[:ensure] = :absent
    else
      proxy = self.class.proxies(@property_hash[:proxyid]).find { |p| p['host'] == @resource[:hostname] }
      @property_hash = self.class.proxy_properties_hash(proxy)
    end
  end

  def mode=(value)
    @property_flush[:mode] = value
  end

  def change_to_passive_proxy
    Puppet.debug("We're changing to a passive proxy")
    # We need to call zbx.proxies.update with an `interface` hash.

    useip = if @resource[:use_ip].nil?
              1 # Default to true
            else
              @resource[:use_ip] == :true ? 1 : 0
            end

    interface = {
      ip: @resource[:ipaddress] || @property_hash[:ipaddress] || '127.0.0.1',
      dns: @resource[:hostname], # This is the namevar and will always exist
      useip: useip,
      port: @resource[:port] || @property_hash[:port] || 10_051
    }

    zbx.proxies.update(
      {
        proxyid: @property_hash[:proxyid],
        status: self.class.mode_to_status(:passive),
        interface: interface
      },
      true
    )
  end

  def change_to_active_proxy
    Puppet.debug("We're changing to an active proxy")
    zbx.proxies.update(
      {
        proxyid: @property_hash[:proxyid],
        status: self.class.mode_to_status(:active)
      },
      true
    )
  end

  def update_interface_properties
    useip = if @resource[:use_ip].nil?
              nil # Don't provide a default. Keep use_ip unmanaged.
            else
              @resource[:use_ip] == :true ? 1 : 0
            end

    interface = {
      interfaceid: @property_hash[:interfaceid],
      ip: @resource[:ipaddress],
      useip: useip,
      port: @resource[:port]
    }.compact

    zbx.proxies.update(
      {
        proxyid: @property_hash[:proxyid],
        interface: interface
      },
      true
    )
  end

  def update
    if @property_flush[:mode] == :passive
      change_to_passive_proxy
      return
    end

    if @property_flush[:mode] == :active
      change_to_active_proxy
      return
    end

    # At present, the only properties other than mode that can be updated are the interface properties applicable to passive proxies only.
    raise Puppet::Error, "Can't update proxy interface properties for an active proxy" unless @property_hash[:mode] == :passive

    update_interface_properties
  end

  def self.status_to_mode(status)
    case status.to_i
    when 5
      :active
    when 6
      :passive
    else
      raise Puppet::Error, 'zabbix API returned invalid value for `status`'
    end
  end

  def self.mode_to_status(mode)
    return 5 if mode == :active

    6
  end
end
