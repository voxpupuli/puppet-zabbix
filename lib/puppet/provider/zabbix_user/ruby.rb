# frozen_string_literal: true

require_relative '../zabbix'
Puppet::Type.type(:zabbix_user).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  desc 'Puppet provider for managing Zabbix User. It uses the Zabbix API to create, read, update and delete user.'
  confine feature: :zabbixapi

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def get_id(username)
    zbx.users.get_raw(filter: { username: username }, output: 'userid')[0]['userid']
  end

  def get_user_by_name(username)
    api_user = zbx.users.get_raw(filter: { username: username }, selectUsrgrps: 'extend')
    if api_user.empty?
      nil
    else
      {
        username: api_user[0]['username'],
        firstname: api_user[0]['name'],
        surname: api_user[0]['surname'],
        autologin: api_user[0]['autologin'],
        role: zbx.roles.get_raw(filter: { roleid: api_user[0]['roleid'] })[0]['name'],
        usrgrps: api_user[0]['usrgrps'].map { |h| h['name'] }.compact,
      }
    end
  end

  def user
    @user ||= get_user_by_name(resource[:username])
    @user
  end

  attr_writer :user

  def username
    user[:username]
  end

  def username=(value)
    @property_flush[:username] = value
  end

  def passwd
    nil
  end

  def passwd=(value)
    @property_flush[:passwd] = value
  end

  def firstname
    user[:firstname]
  end

  def firstname=(value)
    @property_flush[:name] = value
  end

  def surname
    user[:surname]
  end

  def surname=(value)
    @property_flush[:surname] = value
  end

  def autologin
    user[:autologin]
  end

  def autologin=(int)
    @property_flush[:autologin] = int
  end

  def role
    user[:role]
  end

  def role=(value)
    @property_flush[:role] = value
  end

  def usrgrps
    user[:usrgrps]
  end

  def usrgrps=(array)
    @property_flush[:usrgrps] = array
  end

  def flush
    if @property_flush[:ensure] == :absent
      delete_user
      return
    end

    return if @property_flush.empty?

    update_user
  end

  def update_user
    # Get roleid if needs updating
    unless @property_flush[:role].nil?
      @property_flush[:roleid] = zbx.roles.get_id(name: @property_flush[:role])
      @property_flush.delete(:role)
    end
    # Get usrgrpids if need updating
    unless @property_flush[:usrgrps].nil?
      usrgrp_ids = zbx.usergroups.get_raw(filter: { name: @property_flush[:usrgrps] }, output: 'usrgrpid')
      @property_flush[:usrgrps] = usrgrp_ids
    end
    zbx.query(
      method: 'user.update',
      params: {
        userid: get_id(@resource[:username]),
      }.merge(@property_flush)
    )
  end

  def delete_user
    zbx.users.delete(get_id(@resource[:username]))
  end

  def check_password
    protocol = api_config['default']['apache_use_ssl'] == 'true' ? 'https' : 'http'
    begin
      zbx_check = ZabbixApi.connect(
        url: "#{protocol}://#{api_config['default']['zabbix_url']}/api_jsonrpc.php",
        user: @resource[:username],
        password: @resource[:passwd],
        http_user: @resource[:username],
        http_password: @resource[:passwd],
        ignore_version: true
      )
    rescue ZabbixApi::ApiError
      ret = false
    else
      ret = true
      zbx_check.query(method: 'user.logout', params: {})
    end
    ret
  end

  def create
    # Get role id
    roleid = zbx.roles.get_id(name: @resource[:role])
    # Get usrgrp ids
    usrgrps = @resource[:usrgrps].empty? ? {} : zbx.usergroups.get_raw(filter: { name: @resource[:usrgrps] }, output: 'usrgrpid')

    zbx.users.create(
      username: @resource[:username],
      name: @resource[:firstname],
      surname: @resource[:surname],
      autologin: @resource[:autologin].nil? ? 0 : @resource[:autologin],
      roleid: roleid,
      usrgrps: usrgrps,
      passwd: @resource[:passwd]
    )
  end

  def exists?
    user
  end

  def destroy
    @property_flush[:ensure] = :absent
  end
end
