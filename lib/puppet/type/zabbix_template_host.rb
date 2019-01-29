Puppet::Type.newtype(:zabbix_template_host) do
  @doc = <<-DOC
    Link or Unlink template to host.
	  Example.
	  Name should be in the format of "template_name@hostname"

	  zabbix_template_host{ 'mysql_template@db1':
      ensure => present,
    }
  DOC

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    newvalues(%r{.+\@.+})
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
