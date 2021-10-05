Puppet::Type.newtype(:zabbix_host) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  def initialize(*args)
    super

    # Migrate group to groups
    return if self[:group].nil?
    self[:groups] = self[:group]
    delete(:group)
  end

  def munge_boolean(value)
    case value
    when true, 'true', :true
      true
    when false, 'false', :false
      false
    else
      raise(Puppet::Error, 'munge_boolean only takes booleans')
    end
  end

  newparam(:hostname, namevar: true) do
    desc 'FQDN of the machine.'
  end

  newproperty(:id) do
    desc 'Internally used hostid'

    validate do |_value|
      raise(Puppet::Error, 'id is read-only and is only available via puppet resource.')
    end
  end

  newproperty(:interfaceid) do
    desc 'Internally used identifier for the host interface'

    validate do |_value|
      raise(Puppet::Error, 'interfaceid is read-only and is only available via puppet resource.')
    end
  end

  newproperty(:ipaddress) do
    desc 'The IP address of the machine running zabbix agent.'
  end

  newproperty(:interfacetype, int: 1) do
    desc 'Interface type. 1 for zabbix agent.'
  end

  newproperty(:interfacedetails) do
    desc 'Additional interface details.'

    def insync?(is)
      is.to_s == should.to_s
    end
  end

  newproperty(:use_ip, boolean: true) do
    desc 'Using ipadress instead of dns to connect.'

    newvalues(true, false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:port) do
    desc 'The port that the zabbix agent is listening on.'
    def insync?(is)
      is.to_i == should.to_i
    end
  end

  newproperty(:group) do
    desc 'Deprecated! Name of the hostgroup.'

    validate do |_value|
      Puppet.warning('Passing group to zabbix_host is deprecated and will be removed. Use groups instead.')
    end
  end

  newproperty(:groups, array_matching: :all) do
    desc 'An array of groups the host belongs to.'
    def insync?(is)
      is.sort == should.sort
    end
  end

  newparam(:group_create, boolean: true) do
    desc 'Create hostgroup if missing.'

    newvalues(true, false)

    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:templates, array_matching: :all) do
    desc 'List of templates which should be loaded for this host.'
    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:macros, array_matching: :all) do
    desc 'Array of hashes (macros) which should be loaded for this host.'
    def insync?(is)
      is.sort_by(&:first) == should.sort_by(&:first)
    end
  end

  newproperty(:proxy) do
    desc 'Whether it is monitored by an proxy or not.'
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }

  validate do
    raise(_('The properties group and groups are mutually exclusive.')) if self[:group] && self[:groups]
  end
end
