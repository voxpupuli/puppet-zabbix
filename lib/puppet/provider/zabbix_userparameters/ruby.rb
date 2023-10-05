# frozen_string_literal: true

require_relative '../zabbix'
Puppet::Type.type(:zabbix_userparameters).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  desc 'Puppet provider that manages Zabbix user parameters. It allows users to define custom monitoring parameters in Zabbix, and provides methods for creating and checking the existence of a user parameter. It also has a placeholder method for destroying the user parameter.'
  confine feature: :zabbixapi

  def create
    host = @resource[:hostname]
    template = @resource[:template]

    # Find the template_id we are looking for and add it to the host
    template_id = get_template_id(zbx, template)
    zbx.templates.mass_add(
      hosts_id: [zbx.hosts.get_id(host: host)],
      templates_id: [template_id]
    )
  end

  def exists?
    host = @resource[:hostname]
    template = @resource[:template]
    check_template_in_host(host, template)
  end

  def destroy
    # TODO: Implement?!
    true
  end
end
