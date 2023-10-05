# frozen_string_literal: true

Puppet::Type.newtype(:zabbix_hostgroup) do
  @doc = 'Manage zabbix hostgroups'

  ensurable do
    desc 'The basic property that the resource should be in.'
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'hostgroup name'
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
