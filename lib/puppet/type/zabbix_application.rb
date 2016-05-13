$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))
require 'puppet/util/zabbix'

Puppet::Type.newtype(:zabbix_application) do
  @doc = %q(Manage zabbix applications

    Example.
      Zabbix_application {
        zabbix_url => 'zabbix_server1',
        zabbix_user => 'admin',
        zabbix_pass => 'zabbix',
      }

      zabbix_application{"app1":
        ensure   => present,
        template => 'template1',
      }

  It Raise exception on deleting an application which is a part of used template.

  )

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'application name'
  end

  newparam(:template) do
    desc 'template to which the application is linked'
  end

  Puppet::Util::Zabbix.add_zabbix_type_methods(self)
end
