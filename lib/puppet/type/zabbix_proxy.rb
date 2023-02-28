# frozen_string_literal: true

Puppet::Type.newtype(:zabbix_proxy) do
  desc 'Zabbix proxy type'
  ensurable do
    defaultvalues
    defaultto :present
  end

  def munge_boolean_to_symbol(value)
    # insync? doesn't work with actual booleans
    # see https://tickets.puppetlabs.com/browse/PUP-2368
    value = value.downcase if value.respond_to? :downcase

    case value
    when true, :true, 'true', :yes, 'yes'
      :true
    when false, :false, 'false', :no, 'no'
      :false
    else
      raise ArgumentError, 'expected a boolean value'
    end
  end

  # Standard properties
  newparam(:hostname, namevar: true) do
    desc 'FQDN of the proxy.'
  end

  newproperty(:mode) do
    desc 'The kind of mode the proxy running. Active (0) or passive (1).'

    newvalues(:active, :passive, 0, 1, '0', '1')

    munge do |value|
      case value
      when 0, '0'
        :active
      when 1, '1'
        :passive
      else
        super(value)
      end
    end
  end

  newproperty(:proxyid) do
    desc '(readonly) ID of the proxy'
    validate { |_val| raise Puppet::Error, 'proxyid is read-only' }
  end

  # Interface properties (applicable to passive proxies)
  newproperty(:ipaddress) do
    desc 'The IP address of the machine running zabbix proxy.'

    validate do |value|
      require 'ipaddr'

      begin
        IPAddr.new(value)
      rescue StandardError => e
        raise Puppet::Error, e.to_s
      end
    end
  end

  newproperty(:use_ip) do
    desc 'Using ipadress instead of dns to connect. Is used by the zabbix-api command.'

    munge { |value| @resource.munge_boolean_to_symbol(value) }
  end

  newproperty(:port) do
    desc 'The port that the zabbix proxy is listening on.'

    validate do |value|
      if value.is_a?(String)
        raise Puppet::Error, 'invalid port' unless value =~ %r{^\d+$}
        raise Puppet::Error, 'invalid port' unless value.to_i.between?(1, 65_535)

        return
      end
      if value.is_a?(Integer)
        raise Puppet::Error, 'invalid port' unless value.between?(1, 65_535)

        return
      end
      raise Puppet::Error, 'invalid port'
    end

    munge(&:to_i)
  end

  newproperty(:interfaceid) do
    desc '(readonly) ID of the interface'
    validate { |_val| raise Puppet::Error, 'interfaceid is read-only' }
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
