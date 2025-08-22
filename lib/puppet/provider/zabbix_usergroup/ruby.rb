# frozen_string_literal: true

require_relative '../zabbix'
Puppet::Type.type(:zabbix_usergroup).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  desc 'Puppet provider for managing Zabbix usergroup. It uses the Zabbix API to create, read, update and delete usergroup.'
  confine feature: :zabbixapi

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def get_usrgrp_by_name(grpname)
    api_usrgrp = zbx.usergroups.get(name: grpname)
    if api_usrgrp.empty?
      nil
    else
      {
        id: api_usrgrp[0]['id'],
        name: api_usrgrp[0]['name'],
        gui_access: api_usrgrp[0]['gui_access'],
        debug_mode: api_usrgrp[0]['debug_mode'] ? 1 : 0,
        users_status: api_usrgrp[0]['users_status'],
      }
    end
  end

  def usergroup
    @usergroup ||= get_usrgrp_by_name(resource[:name])
    @usergroup
  end

  attr_writer :usergroup

  def gui_access
    usergroup[:gui_access]
  end

  def gui_access=(int)
    @property_flush[:gui_access] = int
  end

  def debug_mode
    usergroup[:debug_mode]
  end

  def debug_mode=(int)
    @property_flush[:debug_mode] = int
  end

  def users_status
    usergroup[:users_status]
  end

  def users_status=(int)
    @property_flush[:users_status] = int
  end

  def flush
    if @property_flush[:ensure] == :absent
      delete_usrgrp
      return
    end

    return if @property_flush.empty?

    update_usrgrp
  end

  def update_usrgrp
    zbx.query(
      method: 'usergroup.update',
      params: {
        usrgrpid: zbx.usergroups.get_id(name: @resource[:name]),
      }.merge(@property_flush)
    )
  end

  def delete_usrgrp
    zbx.usergroups.delete(zbx.usergroups.get_id(name: @resource[:name]))
  end

  def create
    params = {}
    params[:name] = @resource[:name]
    params[:gui_access] = @resource[:gui_access] unless @resource[:gui_access].nil?
    params[:debug_mode] = @resource[:debug_mode] unless @resource[:debug_mode].nil?
    params[:users_status] = @resource[:users_status] unless @resource[:users_status].nil?

    zbx.usergroups.create(params)
  end

  def exists?
    usergroup
  end

  def destroy
    @property_flush[:ensure] = :absent
  end
end
