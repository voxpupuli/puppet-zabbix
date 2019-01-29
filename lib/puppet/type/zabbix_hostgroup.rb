Puppet::Type.newtype(:zabbix_hostgroup) do
  @doc = 'Manage zabbix hostgroups'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'hostgroup name'
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
