Puppet::Type.newtype(:zabbix_userparameters) do

    ensurable do
        defaultvalues
        defaultto :present
    end

    newparam(:name, :namevar => true) do
        desc 'An arbitrary name used as the identity of the resource.'
    end

    newparam(:hostname) do
        desc 'An arbitrary name used as the identity of the resource.'
    end

    newparam(:template) do
        desc 'Templates which should be loaded for this host.'
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
