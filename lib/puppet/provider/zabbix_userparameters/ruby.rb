require_relative '../zabbix'
Puppet::Type.type(:zabbix_userparameters).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :aws

  def create
    host = @resource[:hostname]
    template = @resource[:template]
    zabbix_url = @resource[:zabbix_url]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]

    # Create the connection
    zbx = self.class.create_connection(zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)

    # Find the template_id we are looking for and add it to the host
    template_id = self.class.get_template_id(zbx, template)
    zbx.templates.mass_add(
      hosts_id: [zbx.hosts.get_id(host: host)],
      templates_id: [template_id]
    )
  end

  def exists?
    host = @resource[:hostname]
    template = @resource[:template]
    zabbix_url = @resource[:zabbix_url]
    zabbix_user = @resource[:zabbix_user]
    zabbix_pass = @resource[:zabbix_pass]
    apache_use_ssl = @resource[:apache_use_ssl]

    self.class.check_template_in_host(host, template, zabbix_url, zabbix_user, zabbix_pass, apache_use_ssl)
  end

  def destroy
    # TODO: Implement?!
    true
  end
end
