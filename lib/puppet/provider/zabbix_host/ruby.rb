require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_host).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  def create
    zabbix_url = @resource[:zabbix_url]

    self.class.require_zabbix if zabbix_url != ''

    # Set some vars
    host = @resource[:hostname]
    ipaddress = @resource[:ipaddress]
    use_ip = @resource[:use_ip]
    port = @resource[:port]
    hostgroup = @resource[:group]
    hostgroup_create = @resource[:group_create]
    templates = @resource[:templates]
    proxy = @resource[:proxy]
    zabbix_url = @resource[:zabbix_url]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]

    # Connect to zabbix api
    zbx = self.class.create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)

    # Get the template ids.
    template_array = []
    if templates.is_a?(Array)
      templates.each do |template|
        template_id = self.class.get_template_id(zbx, template)
        template_array.push template_id
      end
    else
      template_array.push self.class.get_template_id(zbx, templates)
    end

    # Check if we need to connect via ip or fqdn
    use_ip = use_ip ? 1 : 0

    # When using DNS you still have to send a value for ip
    ipaddress = '' if ipaddress.nil? && use_ip.zero?

    hostgroup_create = hostgroup_create ? 1 : 0

    # First check if we have an correct hostgroup and if not, we raise an error.
    search_hostgroup = zbx.hostgroups.get_id(name: hostgroup)
    if search_hostgroup.nil? && hostgroup_create == 1
      zbx.hostgroups.create(name: hostgroup)
      search_hostgroup = zbx.hostgroups.get_id(name: hostgroup)
    elsif search_hostgroup.nil? && hostgroup_create.zero?
      raise Puppet::Error, 'The hostgroup (' + hostgroup + ') does not exist in zabbix. Please use the correct one.'
    end

    # Now we create the host
    hostid = zbx.hosts.create_or_update(
      host: host,
      interfaces: [
        {
          type: 1,
          main: 1,
          ip: ipaddress,
          dns: host,
          port: port,
          useip: use_ip
        }
      ],
      templates: template_array,
      groups: [groupid: search_hostgroup]
    )

    zbx.templates.mass_add(hosts_id: [hostid], templates_id: template_array)

    return if proxy.nil? || proxy.empty?
    zbx.hosts.update(
      hostid: zbx.hosts.get_id(host: host),
      proxy_hostid: zbx.proxies.get_id(host: proxy)
    )
  end

  def exists?
    zabbix_url = @resource[:zabbix_url]

    self.class.require_zabbix if zabbix_url != ''

    host = @resource[:hostname]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]
    templates = @resource[:templates]

    templates = [templates] unless templates.is_a?(Array)

    res = []
    res.push(self.class.check_host(host, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl))
    templates.each do |template|
      res.push(self.class.check_template_in_host(host, template, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl))
    end
    res.all?
  end

  def destroy
    zabbix_url = @resource[:zabbix_url]

    self.class.require_zabbix if zabbix_url != ''

    host = @resource[:hostname]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]

    zbx = self.class.create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
    zbx.hosts.delete(zbx.hosts.get_id(host: host))
  end
end
