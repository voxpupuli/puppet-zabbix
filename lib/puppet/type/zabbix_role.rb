# frozen_string_literal: true

Puppet::Type.newtype(:zabbix_role) do
  @doc = %q("Manage zabbix role objects

      zabbix_role { 'My custom role':
        ensure => present,
        type => 'Admin',
        readonly => false,
        rules => {
          'ui'=> [
             {
               'name' => 'configuration.actions',
               'status' => '1'
             },
             {
               'name' => 'configuration.discovery',
               'status'=>'0'
             },
          ],
          'ui.default_access' => '1',
          'services.read.mode' => '1',
          'services.write.mode' => '0',
          'modules.default_access' => '0',
          'api.access' => '0',
        }
      }")

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'the name of the role'
    validate do |value|
      raise ArgumentError, "role must be a valid string, \"#{value}\" is not" unless value.is_a?(String)
    end
  end

  newproperty(:type) do
    desc 'role type'
    newvalues('User', 'Admin', 'Super admin')
    defaultto 'User'

    type_values = {
      'User'        => 1,
      'Admin'       => 2,
      'Super admin' => 3,
    }

    munge do |value|
      type_values[value]
    end
  end

  newproperty(:readonly, boolean: true) do
    desc 'Whether the role is readonly'
    newvalues(true, false)
    defaultto false
    munge do |value|
      value ? 1 : 0
    end
  end

  newproperty(:rules) do
    desc 'The role rules'

    def insync?(_is)
      provider.check_rules
    end

    def change_to_s(currentvalue, newvalue)
      md5_cur = Digest::MD5.hexdigest currentvalue.to_s
      md5_new = Digest::MD5.hexdigest newvalue.to_s
      Puppet.debug("OLD rules: #{currentvalue}")
      Puppet.debug("NEW rules: #{newvalue}")
      "changed #{md5_cur} to #{md5_new}"
    end

    def is_to_s(currentvalue)
      Digest::MD5.hexdigest currentvalue.to_s
    end

    def should_to_s(newvalue)
      Digest::MD5.hexdigest newvalue.to_s
    end

    validate do |value|
      raise ArgumentError, 'rules must be a hash' unless value.is_a?(Hash)
    end
  end

  autorequire(:file) { '/etc/zabbix/api.conf' }
end
