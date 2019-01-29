require_relative '../zabbix'
Puppet::Type.type(:zabbix_application).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :zabbixapi

  def template_id
    @template_id ||= zbx.templates.get_id(host: @resource[:template])
  end

  def create
    zbx.applications.create(
      name: @resource[:name],
      hostid: template_id
    )
  end

  def application_id
    @application_id ||= zbx.applications.get_id(name: @resource[:name])
  end

  def exists?
    zbx.applications.get_id(name: @resource[:name])
  end

  def destroy
    zbx.applications.delete(application_id)
  rescue => error
    raise(Puppet::Error, "Zabbix Application Delete Failed\n#{error.message}")
  end
end
