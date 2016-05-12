require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_proxy).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  def create
    zabbix_url = @resource[:zabbix_url]

    # Check if we have an zabbix_url. If so, we are about
    # to run on the zabbix-server.
    self.class.require_zabbix if zabbix_url != ''

    # Set some vars
    host = @resource[:hostname]
    ipaddress = @resource[:ipaddress]
    use_ip = @resource[:use_ip]
    port = @resource[:port]
    templates = @resource[:templates]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]

    zbx = self.class.create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)

    # Get the template ids.
    template_array = []
    if templates.is_a?(Array) == true
      templates.each do |template|
        template_id = self.class.get_template_id(zbx, template)
        template_array.push template_id
      end
    else
      template_array.push templates
    end

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
    zabbix_url = @resource[:zabbix_url]

    self.class.require_zabbix if zabbix_url != ''

    host = @resource[:hostname]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]

    self.class.check_proxy(host, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
  end
end
