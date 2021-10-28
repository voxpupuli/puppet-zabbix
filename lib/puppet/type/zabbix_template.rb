Puppet::Type.newtype(:zabbix_template) do
  ensurable do
    defaultvalues
    defaultto :present

    def insync?(is)
      return false if is == :present && !template_xmls_match?
      super
    end

    def template_xmls_match?
      clean_xml(source_xml) == clean_xml(provider.xml)
    end

    def source_xml
      file = File.new(resource[:template_source], 'rb')
      file.read
    end

    def clean_xml(dirty)
      dirty.gsub(%r{>\s*}, '>').gsub(%r{\s*<}, '<').gsub(%r{<date>.*<\/date>}, 'DATEWASHERE')
    end

    def change_to_s(currentvalue, newvalue)
      return 'Template updated' if currentvalue == :present && newvalue == :present
      super
    end
  end

  newparam(:template_name, namevar: true) do
    desc 'The name of template.'
  end

  newparam(:template_source) do
    desc 'Template source file.'
  end

  newparam(:zabbix_version) do
    desc 'Zabbix version that the template will be installed on.'
  end

  newparam(:delete_missing_applications, boolean: true) do
    desc 'Delete applications from zabbix which are not in the template.'
  end

  newparam(:delete_missing_drules, boolean: true) do
    desc 'Delete discovery rules from zabbix which are not in the template.'
  end

  newparam(:delete_missing_graphs, boolean: true) do
    desc 'Delete graphs from zabbix which are not in the template.'
  end

  newparam(:delete_missing_httptests, boolean: true) do
    desc 'Delete web scenarios from zabbix which are not in the template.'
  end

  newparam(:delete_missing_items, boolean: true) do
    desc 'Delete items from zabbix which are not in the template.'
  end

  newparam(:delete_missing_templatescreens, boolean: true) do
    desc 'Delete templateScreens from zabbix which are not in the template.'
  end

  newparam(:delete_missing_triggers, boolean: true) do
    desc 'Delete triggers from zabbix which are not in the template.'
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
