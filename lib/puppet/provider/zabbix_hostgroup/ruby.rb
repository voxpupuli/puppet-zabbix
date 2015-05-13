require File.expand_path(File.join(File.dirname(__FILE__), '..', 'zabbix'))
Puppet::Type.type(:zabbix_hostgroup).provide(:ruby, :parent => Puppet::Provider::Zabbix) do

  def connect
    if @resource[:zabbix_url] != ''
      self.class.require_zabbix
    end

    @zbx ||= self.class.create_connection(@resource[:zabbix_url],@resource[:zabbix_user],@resource[:zabbix_pass],@resource[:apache_use_ssl])
    return @zbx
  end

  def create 
    # Connect to zabbix api
    zbx = connect
    hgid = zbx.hostgroups.create(:name => @resource[:name])
  end

  def exists?
    zbx = connect
    zbx.hostgroups.get_id(:name => @resource[:name])
  end

  def destroy
    zbx = connect
    zbx.hostgroups.delete(zbx.hostgroups.get_id(:name => @resource[:name]))
  end

end
