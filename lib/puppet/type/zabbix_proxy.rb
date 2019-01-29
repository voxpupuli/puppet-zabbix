Puppet::Type.newtype(:zabbix_proxy) do
  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:hostname, namevar: true) do
    desc 'FQDN of the machine.'
  end

  newparam(:ipaddress) do
    desc 'The IP address of the machine running zabbix proxy.'
  end

  newparam(:use_ip) do
    desc 'Using ipadress instead of dns to connect. Is used by the zabbix-api command.'
  end

  newparam(:mode) do
    desc 'The kind of mode the proxy running. Active (0) or passive (1).'
  end

  newparam(:port) do
    desc 'The port that the zabbix proxy is listening on.'
  end

  newparam(:templates) do
    desc 'Template which should be loaded for this host.'
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
