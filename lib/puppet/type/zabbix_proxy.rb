Puppet::Type.newtype(:zabbix_proxy) do

    ensurable do
        defaultvalues
        defaultto :present
    end

    newparam(:hostname, :namevar => true) do
        desc 'An arbitrary name used as the identity of the resource.'
    end

    newparam(:ipaddress) do
        desc 'The DNS name or IP address of the machine running zabbix agent.'
    end

    newparam(:use_ip) do
        desc 'The DNS name or IP address of the machine running zabbix agent.'
    end

    newparam(:mode) do
        desc 'The DNS name or IP address of the machine running zabbix agent.'
    end

    newparam(:port) do
        desc 'The port that the zabbix agent is listening on.'
    end

    newparam(:templates) do
        desc 'List of templates which should be loaded for this host.'
    end

    newparam(:zabbix_url) do
        desc 'Whether it is monitored by an proxy or not.'
    end

    newparam(:zabbix_user) do
        desc 'Whether it is monitored by an proxy or not.'
    end

    newparam(:zabbix_pass) do
        desc 'Whether it is monitored by an proxy or not.'
    end

end
