class Puppet::Provider::Zabbix < Puppet::Provider

    # Require the zabbixapi gem
    def self.require_zabbix
        require "zabbixapi"    
    end

    # Create the api connection
    def self.create_connection(zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
        if apache_use_ssl
            protocol = 'https'
        else
            protocol = 'http'
        end
        zbx = ZabbixApi.connect(
            :url => "#{protocol}://#{zabbix_url}/api_jsonrpc.php",
            :user => zabbix_user,
            :password => zabbix_pass
        )
        return zbx
    end

    # Check if host exists. When error raised, return false.
    def self.check_host(host,zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
        begin
            zbx = create_connection(zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
            zbx.hosts.get_id(:host => host)
        rescue Puppet::ExecutionFailure => e
            false
        end
    end

    # Check if proxy exists. When error raised, return false.
    def self.check_proxy(host,zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
        begin
            require_zabbix
            zbx = create_connection(zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
            zbx.proxies.get_id(:host => host)
        rescue Puppet::ExecutionFailure => e
            false
        end
    end

    # Get the template id from the name.
    def self.get_template_id(zbx,template)
        if self.is_a_number?(template)
            return template
        else
            id = zbx.templates.get_id( :host => template )
            return id
        end
    end

    # Check if given template name exists in current host.
    def self.check_template_in_host(host,template,zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
        zbx = create_connection(zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
        template_id = self.get_template_id(zbx,template)
        template_array = Array.new
        template_array = zbx.templates.get_ids_by_host( :hostids => [zbx.hosts.get_id(:host => host)] )

        template_array.include?("#{template_id}")
    end

    def self.check_template_exist(template,template_source,zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
        begin
            zbx = create_connection(zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
            zbx.templates.get_id( :host => template )
        rescue Puppet::ExecutionFailure => e
            false
        end
    end

    def self.check_template_is_equal(template,template_source,zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
        begin
            zbx = create_connection(zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
            exported = zbx.configurations.export(
                :format => "xml",
                :options => {
                    :templates => [zbx.templates.get_id(:host => template)]
                }
            )
            exported_clean = exported.gsub(/>\s*/, ">").gsub(/\s*</, "<").gsub(/<date>.*<\/date>/,"DATEWASHERE")
            template_source_clean = template_source.gsub(/>\s*/, ">").gsub(/\s*</, "<").gsub(/<date>.*<\/date>/,"DATEWASHERE")
            exported_clean.eql? template_source_clean
        rescue Puppet::ExecutionFailure => e
            false
        end
    end

    # Is it an number?
    def self.is_a_number?(s)
        s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

end
