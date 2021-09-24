require_relative '../zabbix'
Puppet::Type.type(:zabbix_template).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  confine feature: :zabbixapi

  def create
    zbx.configurations.import(
      format: 'xml',
      rules: {
        # application parameter was removed on Zabbix 5.4
        (@resource[:zabbix_version] =~ %r{[45]\.[02]} ? :applications : nil) => {
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
        # screens parameter was removed on Zabbix 5.4
        (@resource[:zabbix_version] =~ %r{[45]\.[02]} ? :screens : nil) => {
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
        # templateDashboards was renamed to templateScreen on Zabbix >= 5.2
        (@resource[:zabbix_version] =~ %r{5\.[24]} ? :templateDashboards : :templateScreens) => {
          createMissing: true,
          updateExisting: true
        },
        triggers: {
          createMissing: true,
          updateExisting: true
        }
      }.delete_if { |key, _| key.nil? },
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
