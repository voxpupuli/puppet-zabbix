$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))
require 'puppet/util/zabbix'

Puppet::Type.newtype(:zabbix_hostgroup) do
  @doc = 'Manage zabbix hostgroups'

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'hostgroup name'
  end

  Puppet::Util::Zabbix.add_zabbix_type_methods(self)
end
