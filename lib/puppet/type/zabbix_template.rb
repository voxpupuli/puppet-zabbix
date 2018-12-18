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

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
