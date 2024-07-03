# frozen_string_literal: true

Puppet::Type.newtype(:zabbix_application) do
  @doc = <<-DOC
    Manage zabbix applications

    Example:
      zabbix_application{"app1":
        ensure   => present,
        template => 'template1',
      }
    It Raise exception on deleting an application which is a part of used template.
  DOC

  ensurable do
    desc 'The basic property that the resource should be in.'
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
