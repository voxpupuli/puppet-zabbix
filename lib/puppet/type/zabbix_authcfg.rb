# frozen_string_literal: true

require 'uri'

Puppet::Type.newtype(:zabbix_authcfg) do
  @doc = %q("Manage zabbix authentication configuration

      zabbix_authcfg { '1':
        ensure                => present,
        ldap_configured       => true,
        ldap_host             => 'ldap://host.name',
        ldap_port             => '389',
        ldap_base_dn          => 'dc=example,dc=com',
        ldap_search_attribute => 'uid',
        ldap_bind_dn          => 'cn=Manager',
        ldap_bind_password    => Sensitive('password'),
        ldap_case_sensitive   => true,
      }")

  ensurable do
    # We should not be able to delete the authentication settings
    newvalues(:present)
    defaultto :present
  end

  newparam(:id, namevar: true) do
    # Zabbix 5, 6 only support updating the default authentication settings (id: 1)
    desc 'authentication settings id'
    newvalues(1)
  end

  newproperty(:authentication_type) do
    desc 'authentication type'
    newvalues('internal', 'LDAP')
    defaultto 'internal'
    munge do |value|
      value == 'internal' ? 0 : 1
    end
  end

  newproperty(:ldap_configured, boolean: true) do
    desc 'Enable LDAP authentication'
    newvalues(true, false)
    defaultto true
    munge do |value|
      value ? 1 : 0
    end
  end

  newproperty(:ldap_host) do
    desc 'LDAP host'
    validate do |value|
      raise ArgumentError, "ldap_host must be a valid ldap uri, \"#{value}\" is not" unless value =~ URI::DEFAULT_PARSER.make_regexp
    end
  end

  newproperty(:ldap_port) do
    desc 'LDAP port'
    validate do |value|
      raise ArgumentError, "ldap_port must be an Integer, not #{value}" unless value.is_a?(Integer)
    end
  end

  newproperty(:ldap_base_dn) do
    desc 'LDAP base DN'
    validate do |value|
      raise ArgumentError, "ldap_base_dn must be a valid DN, not #{value}" unless %r{^((dc|ou|cn)=.+,*)+$}i.match?(value)
    end
  end

  newproperty(:ldap_search_attribute) do
    desc 'LDAP search attribute'
    newvalues('uid', 'sAMAccountName')
  end

  newproperty(:ldap_bind_dn) do
    desc 'LDAP bind DN'
    validate do |value|
      raise ArgumentError, "ldap_bind_dn must be a valid DN, not #{value}" unless %r{^((dc|ou|cn)=.+,*)+$}i.match?(value)
    end
  end

  newproperty(:ldap_case_sensitive, boolean: true) do
    desc 'LDAP case sensitive login'
    newvalues(true, false)
    defaultto true
    munge do |value|
      value ? 1 : 0
    end
  end

  newproperty(:ldap_bind_password) do
    desc 'LDAP bind password'
    validate do |value|
      raise ArgumentError, "ldap_bind_password must be an String, not #{value}" unless value.is_a?(String)
    end
  end

  def set_sensitive_parameters(sensitive_parameters) # rubocop:disable Naming/AccessorMethodName
    parameter(:ldap_bind_password).sensitive = true if parameter(:ldap_bind_password)
    super(sensitive_parameters)
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
