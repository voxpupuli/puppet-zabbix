# frozen_string_literal: true

Puppet::Type.newtype(:zabbix_user) do
  @doc = %q("Manage zabbix users

      zabbix_user{ 'username':
        ensure     => present,
        firstname  => 'firstname',
        surname    => 'surname',
        passwd     => Sensitive(password),
        autologin  => 0,
        role       => 'Admin role',
        usrgrps    => [ 'Group1' ],
      }")

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:username, namevar: true) do
    desc 'user name'
    validate do |value|
      raise ArgumentError, 'username must be a string' unless value.is_a?(String)
    end
  end

  newproperty(:firstname) do
    desc 'user firstname'
    validate do |value|
      raise ArgumentError, 'firstname must be a string' unless value.is_a?(String)
    end
  end

  newproperty(:surname) do
    desc 'user surname'
    validate do |value|
      raise ArgumentError, 'surname must be a string' unless value.is_a?(String)
    end
  end

  newproperty(:passwd) do
    desc 'user password'
    def insync?(_is)
      provider.check_password
    end
  end

  newproperty(:autologin, boolean: true) do
    desc 'Whether auto login is enabled or disabled.'
    newvalues(true, false)
    defaultto false

    munge do |value|
      value ? 1 : 0
    end
  end

  newproperty(:role) do
    desc 'user role'
    defaultto 'User role'
    validate do |value|
      raise ArgumentError, 'User role must be a string' unless value.nil? || value.is_a?(String)
    end
  end

  newproperty(:usrgrps, array_matching: :all) do
    desc 'user groups'
    defaultto []
    def insync?(is)
      is.sort == should.sort
    end
  end

  def set_sensitive_parameters(sensitive_parameters) # rubocop:disable Naming/AccessorMethodName
    parameter(:passwd).sensitive = true if parameter(:passwd)
    super(sensitive_parameters)
  end

  validate do
    required_properties = %i[firstname surname usrgrps]
    required_properties.each do |property|
      raise ArgumentError, "You must provide a #{property}" if self[:ensure] == :present && self[property].nil?
    end
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
