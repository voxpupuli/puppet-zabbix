require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_proxy).provide(:ruby, :parent => Puppet::Provider::Zabbix) do

    def create
        zabbix_url = @resource[:zabbix_url]

        # Check if we have an zabbix_url. If so, we are about
        # to run on the zabbix-server.
        if zabbix_url != ''
            self.class.require_zabbix
        end

        # Set some vars
        host = @resource[:hostname]
        ipaddress = @resource[:ipaddress]
        use_ip = @resource[:use_ip]
        mode = @resource[:mode]
        port = @resource[:port]
        templates = @resource[:templates]
        zabbix_user = @resource[:zabbix_user]
        zabbix_pass = @resource[:zabbix_pass]
        apache_use_ssl = @resource[:apache_use_ssl]

        zbx = self.class.create_connection(zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)

        # Get the template ids.
        template_array = Array.new
        if templates.kind_of?(Array) == true
            for template in templates
                template_id = self.class.get_template_id(zbx,template)
                template_array.push template_id
            end
        else
            template_array.push templates
        end

        # Check if we need to connect via ip or fqdn
        if use_ip == true
            use_ip = 1
        else
            use_ip = 0
        end

        # Find out which mode it is.
        if mode == "0"
            proxy_mode = 5
        else
            proxy_mode = 6
        end

        zbx.proxies.create_or_update(
            :host => host,
            :status => proxy_mode,
            :interfaces => [
                :ip => ipaddress,
                :dns => host,
                :useip => use_ip,
                :port => port
            ]
        )
    end

    def exists?
        zabbix_url = @resource[:zabbix_url]
        
        if zabbix_url != ''
            self.class.require_zabbix
        end
       
        host = @resource[:hostname]
        zabbix_user = @resource[:zabbix_user]
        zabbix_pass = @resource[:zabbix_pass]
        apache_use_ssl = @resource[:apache_use_ssl]

        self.class.check_proxy(host,zabbix_url,zabbix_user,zabbix_pass,apache_use_ssl)
    end

end
