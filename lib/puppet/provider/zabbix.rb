class Puppet::Provider::Zabbix < Puppet::Provider

  def self.require_zabbix
      require "zabbixapi"
  end

  def self.create_connection(zabbix_url,zabbix_user,zabbix_pass)
      zbx = ZabbixApi.connect(
          :url => "http://#{zabbix_url}/api_jsonrpc.php",
          :user => zabbix_user,
          :password => zabbix_pass
      )
      return zbx
  end

  def self.check_host(host,zabbix_url,zabbix_user,zabbix_pass)
      begin
          zbx = create_connection(zabbix_url,zabbix_user,zabbix_pass)
          zbx.hosts.get_id(:host => host)
      rescue Puppet::ExecutionFailure => e
          false
      end
  end

  def self.check_proxy(host,zabbix_url,zabbix_user,zabbix_pass)
      begin
          zbx = create_connection(zabbix_url,zabbix_user,zabbix_pass)
          zbx.proxies.get_id(:host => host)
      rescue Puppet::ExecutionFailure => e
          false
      end
  end

  def self.get_template_id(zbx,template)
      if self.is_a_number?(template)
          return template
      else
          id = zbx.templates.get_id( :host => template )
          return id
      end
  end

  def self.check_template_in_host(host,template,zabbix_url,zabbix_user,zabbix_pass)
      zbx = create_connection(zabbix_url,zabbix_user,zabbix_pass)
      template_id = self.get_template_id(zbx,template)
      template_array = Array.new
      template_array = zbx.templates.get_ids_by_host( :hostids => [zbx.hosts.get_id(:host => host)] )

      template_array.include?("#{template_id}")
  end

  def self.is_a_number?(s)
      s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

end
