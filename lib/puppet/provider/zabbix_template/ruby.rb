require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_template).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  def connect
    self.class.require_zabbix if @resource[:zabbix_url] != ''
    @zbx ||= self.class.create_connection(@resource[:zabbix_url], @resource[:zabbix_user], @resource[:zabbix_pass], @resource[:apache_use_ssl])
    @zbx
  end

  def create
    # Connect to zabbix api
    zbx = connect

    zbx.configurations.import(
      format: 'xml',
      rules: {
        applications: {
          createMissing: true,
          updateExisting: true
        },
        discoveryRules: {
          createMissing: true,
          updateExisting: true
        },
        graphs: {
          createMissing: true,
          updateExisting: true
        },
        groups: {
          createMissing: true
        },
        image: {
          createMissing: true,
          updateExisting: true
        },
        items: {
          createMissing: true,
          updateExisting: true
        },
        maps: {
          createMissing: true,
          updateExisting: true
        },
        screens: {
          createMissing: true,
          updateExisting: true
        },
        templateLinkage: {
          createMissing: true
        },
        templates: {
          createMissing: true,
          updateExisting: true
        },
        templateScreens: {
          createMissing: true,
          updateExisting: true
        },
        triggers: {
          createMissing: true,
          updateExisting: true
        }
      },
      source: template_contents
    )
  end

  def destroy
    zbx = connect
    id = zbx.templates.get_id(host: @resource[:template_name])
    zbx.templates.delete(id)
  end

  def exists?
    zbx = connect
    zbx.templates.get_id(host: @resource[:template_name])
  end

  def xml
    zbx = connect
    zbx.configurations.export(
      format: 'xml',
      options: {
        templates: [zbx.templates.get_id(host: @resource[:template_name])]
      }
    )
  end

  def template_contents
    file = File.new(@resource[:template_source], 'rb')
    file.read
  end
end
