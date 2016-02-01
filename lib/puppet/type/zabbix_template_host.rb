require 'puppet/util/zabbix'

Puppet::Type.newtype(:zabbix_template_host) do
  @doc = %q{Link or Unlink template to host.
	  Example.
	  Name should be in the format of "template_name@hostname"

	  zabbix_template_host{"mysql_template@db1":
            ensure => present
          }
  }

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    newvalues(/.+\@.+/)
    desc 'template_name@host_name'
  end

Puppet::Util::Zabbix.add_zabbix_type_methods(self)

  autorequire(:zabbix_host) do
    self[:name].split('@')[1]
  end

  autorequire(:zabbix_template) do
    self[:name].split('@')[0]
  end
end
