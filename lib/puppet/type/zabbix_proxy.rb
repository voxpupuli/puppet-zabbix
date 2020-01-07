Puppet::Type.newtype(:zabbix_proxy) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:hostname, namevar: true) do
    desc 'FQDN of the machine.'
  end

  newproperty(:ipaddress) do
    desc 'The IP address of the machine running zabbix proxy.'
  end

  newproperty(:use_ip) do
    desc 'Using ipadress instead of dns to connect. Is used by the zabbix-api command.'
  end

  newproperty(:mode) do
    desc 'The kind of mode the proxy running. Active (0) or passive (1).'
  end

  newproperty(:port) do
    desc 'The port that the zabbix proxy is listening on.'
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
