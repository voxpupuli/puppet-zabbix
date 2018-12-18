Puppet::Type.newtype(:zabbix_application) do
  @doc = %q(Manage zabbix applications

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

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
