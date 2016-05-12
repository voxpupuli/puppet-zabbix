require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_template_host).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  def template_name
    @template_name ||= @resource[:name].split('@')[0]
  end

  def template_id
    zbx = connect
    @template_id ||= zbx.templates.get_id(host: template_name)
  end

  def hostname
    @hostname ||= @resource[:name].split('@')[1]
  end

  def hostid
    zbx = connect
    @hostid ||= zbx.hosts.get_id(host: hostname)
  end

  def connect
    self.class.require_zabbix if @resource[:zabbix_url] != ''

    @zbx ||= self.class.create_connection(@resource[:zabbix_url], @resource[:zabbix_user], @resource[:zabbix_pass], @resource[:apache_use_ssl])
    @zbx
  end

  def create
    zbx = connect
    zbx.templates.mass_add(
      hosts_id: [hostid],
      templates_id: [template_id]
    )
  end

  def exists?
    zbx = connect
    zbx.templates.get_ids_by_host(hostids: [hostid]).include?(template_id.to_s)
  end

  def destroy
    zbx = connect
    zbx.templates.mass_remove(
      hosts_id: [hostid],
      templates_id: [template_id]
    )
  end
end
