# frozen_string_literal: true

Puppet::Type.newtype(:zabbix_template_host) do
  @doc = <<-DOC
    Link or Unlink template to host. Only for Zabbix < 6.0!

    Example:
      zabbix_template_host{ 'mysql_template@db1':
        ensure => present,
      }
    Name should be in the format of "template_name@hostname"
  DOC

  ensurable do
    desc 'The basic property that the resource should be in.'
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    newvalues(%r{.+@.+})
    desc 'template_name@host_name'
  end

  autorequire(:zabbix_host) do
    self[:name].split('@')[1]
  end

  autorequire(:zabbix_template) do
    self[:name].split('@')[0]
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
