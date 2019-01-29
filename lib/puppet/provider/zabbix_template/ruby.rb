require_relative '../zabbix'
Puppet::Type.type(:zabbix_template).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :zabbixapi

  def create
    zbx.configurations.import(
      format: 'xml',
      rules: {
        applications: {
          createMissing: true
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
        images: {
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
    id = zbx.templates.get_id(host: @resource[:template_name])
    zbx.templates.delete(id)
  end

  def exists?
    zbx.templates.get_id(host: @resource[:template_name])
  end

  def xml
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
