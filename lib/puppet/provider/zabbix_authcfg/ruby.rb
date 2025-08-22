# frozen_string_literal: true

require_relative '../zabbix'
Puppet::Type.type(:zabbix_authcfg).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  desc 'Puppet provider for managing Zabbix Auth. It uses the Zabbix API to configure authentication.'
  confine feature: :zabbixapi

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def get_auth_by_id(id)
    api_auth = zbx.query(
      method: 'authentication.get',
      params: {
        output: 'extend',
      },
      id: id
    )
    if api_auth.empty?
      nil
    else
      {
        authentication_type: api_auth['authentication_type'],
        ldap_configured: api_auth['ldap_configured'],
        ldap_host: api_auth['ldap_host'],
        ldap_port: api_auth['ldap_port'],
        ldap_base_dn: api_auth['ldap_base_dn'],
        ldap_search_attribute: api_auth['ldap_search_attribute'],
        ldap_bind_dn: api_auth['ldap_bind_dn'],
        ldap_case_sensitive: api_auth['ldap_case_sensitive'],
        ldap_bind_password: api_auth['ldap_bind_password'],
      }
    end
  end

  def auth
    @auth ||= get_auth_by_id(resource[:id])
  end

  attr_writer :auth

  def authentication_type
    auth[:authentication_type]
  end

  def authentication_type=(int)
    @property_flush[:authentication_type] = int
  end

  def ldap_configured
    auth[:ldap_configured]
  end

  def ldap_configured=(int)
    @property_flush[:ldap_configured] = int
  end

  def ldap_host
    auth[:ldap_host]
  end

  def ldap_host=(value)
    @property_flush[:ldap_host] = value
  end

  def ldap_port
    auth[:ldap_port]
  end

  def ldap_port=(value)
    @property_flush[:ldap_port] = value
  end

  def ldap_base_dn
    auth[:ldap_base_dn]
  end

  def ldap_base_dn=(value)
    @property_flush[:ldap_base_dn] = value
  end

  def ldap_search_attribute
    auth[:ldap_search_attribute]
  end

  def ldap_search_attribute=(value)
    @property_flush[:ldap_search_attribute] = value
  end

  def ldap_bind_dn
    auth[:ldap_bind_dn]
  end

  def ldap_bind_dn=(value)
    @property_flush[:ldap_bind_dn] = value
  end

  def ldap_case_sensitive
    auth[:ldap_case_sensitive]
  end

  def ldap_case_sensitive=(int)
    @property_flush[:ldap_case_sensitive] = int
  end

  def ldap_bind_password
    auth[:ldap_bind_password]
  end

  def ldap_bind_password=(value)
    @property_flush[:ldap_bind_password] = value
  end

  def flush
    # ensure => absent is unsupported
    return if @property_flush[:ensure] == :absent

    return if @property_flush.empty?

    update_auth
  end

  def update_auth
    zbx.query(
      method: 'authentication.update',
      id: @resource[:id],
      params: @property_flush
    )
  end

  # Unsupported/not needed since authentication with id: 1 is created by installing zabbix
  def create
    nil
  end

  def exists?
    auth
  end

  # Unused/absent is unsupported
  def destroy
    nil
  end
end
