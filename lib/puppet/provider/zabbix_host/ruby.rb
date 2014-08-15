require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_host).provide(:ruby, :parent => Puppet::Provider::Zabbix) do

  def create 
    zabbix_url = @resource[:zabbix_url]

    if zabbix_url != ''
        self.class.require_zabbix
    end
        
    # Set some vars
    host = @resource[:hostname]
    ipaddress = @resource[:ipaddress]
    use_ip = @resource[:use_ip]
    port = @resource[:port]
    hostgroup = @resource[:group]
    templates = @resource[:templates]
    proxy = @resource[:proxy]
    zabbix_url = @resource[:zabbix_url]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]

    # Connect to zabbix api
    zbx = self.class.create_connection(zabbix_url,zabbix_user,zabbix_pass)
    
    # Get the template ids.
    template_array = Array.new
    for template in templates
        template_id = self.class.get_template_id(zbx,template)
        template_array.push template_id
    end

    # Check if we need to connect via ip or fqdn
    if use_ip == true
        use_ip = 1
    else
        use_ip = 0
    end
 
    # Now we create the host
    zbx.hosts.create_or_update(
      :host => host,
      :interfaces => [
        {
          :type => 1,
          :main => 1,
          :ip => ipaddress,
          :dns => host,
          :port => port,
          :useip => use_ip
        }
      ],
      :templates => template_array,
      :groups => [ :groupid => zbx.hostgroups.get_id(:name => hostgroup) ]
    )

    if proxy != ''
        zbx.hosts.update(
          :hostid => zbx.hosts.get_id(:host => host),
          :proxy_hostid => zbx.proxies.get_id(:host => proxy)
        )
    end
  end

  def exists?
    zabbix_url = @resource[:zabbix_url]

    if zabbix_url != ''
        self.class.require_zabbix
    end

    host = @resource[:hostname]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]

    self.class.check_host(host,zabbix_url,zabbix_user,zabbix_pass)
  end

  def destroy
    zabbix_url = @resource[:zabbix_url]
    
    if zabbix_url != ''
        self.class.require_zabbix
    end

    host = @resource[:hostname]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]

    zbx = self.class.create_connection(zabbix_url,zabbix_user,zabbix_pass)
    zbx.hosts.delete(zbx.hosts.get_id(:host => host))
  end

end
