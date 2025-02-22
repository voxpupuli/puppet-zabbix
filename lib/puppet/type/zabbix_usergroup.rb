# frozen_string_literal: true

Puppet::Type.newtype(:zabbix_usergroup) do
  @doc = %q("Manage zabbix usergroups

      zabbix_usergroup{ 'group1':
        ensure       => present,
        gui_access   => 2,
        debug_mode   => true,
        users_status => true,
      }")

  ensurable do
    desc 'The basic property that the resource should be in.'
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'usergroup name'
  end

  newproperty(:gui_access) do
    desc 'The type of access for this group.'
    newvalues('default', 'internal', 'LDAP', 'none')
    defaultto 'default'

    gui_values = {
      'default'  => 0,
      'internal' => 1,
      'LDAP'     => 2,
      'none'     => 3
    }

    munge do |value|
      gui_values[value]
    end
  end

  newproperty(:debug_mode, boolean: true) do
    desc 'Whether debug mode is enabled or disabled.'
    newvalues(true, false)
    defaultto false

    munge do |value|
      value ? 1 : 0
    end
  end

  newproperty(:users_status, boolean: true) do
    desc 'Whether the user group is enabled or disabled.'
    newvalues(true, false)
    defaultto true

    munge do |value|
      # 0 = enabled in zabbix api...
      value ? 0 : 1
    end
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
