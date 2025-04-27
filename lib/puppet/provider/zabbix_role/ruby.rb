# frozen_string_literal: true

require_relative '../zabbix'
Puppet::Type.type(:zabbix_role).provide(:ruby, parent: Puppet::Provider::Zabbix) do
  desc 'Puppet provider for managing Zabbix role, It use the Zabbix API to create, read, update and delete role.'
  confine feature: :zabbixapi

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def get_id(rolename)
    zbx.roles.get_id(name: rolename)
  end

  def get_role_by_name(name)
    api_role = zbx.roles.get_raw(output: 'extend', selectRules: 'extend', filter: { name: name })
    if api_role.empty?
      nil
    else
      {
        name: api_role[0]['name'],
        type: api_role[0]['type'],
        readonly: api_role[0]['readonly'],
        rules: api_role[0]['rules'],
      }
    end
  end

  def role
    @role ||= get_role_by_name(@resource[:name])
    @role
  end

  attr_writer :role

  def name
    role[:name]
  end

  def name=(value)
    @property_flush[:name] = value
  end

  def type
    role[:type]
  end

  def type=(value)
    @property_flush[:type] = value
  end

  def readonly
    role[:readonly]
  end

  def readonly=(value)
    @property_flush[:readonly] = value
  end

  def rules
    role[:rules]
  end

  def rules=(hash)
    @property_flush[:rules] = hash
  end

  # Defining all rules is cumbersome, this allows for defining just the needed rules, keeping all others to be the zabbix default
  def check_rules
    # Merge 'IS' (role[:rules]) with 'SHOULD' (resource[:rules])
    merged = role[:rules].merge(@resource[:rules]) do |_key, oldval, newval|
      if oldval.is_a?(Array)
        # structure:
        # ui => [ {"name" => "something", value => "something"} ]
        # In case of an array we want uniqueness by hash-name with 'newval' taking precedence
        # we also sort by hash-name to making comparing easy
        (newval + oldval).uniq { |h| h['name'] }.sort_by { |h| h['name'] }
      else
        # not an array: use the new value
        newval
      end
    end
    # make sure the 'IS' (role[:rules]) is sorted to make comparing easy
    is_sorted = role[:rules].to_h { |k, v| v.is_a?(Array) ? [k, v.sort_by { |h| h['name'] }] : [k, v] }
    # if merged equals is_sorted it means that 'should' is contained in 'in' and no action is needed
    # otherwise the value is either wrong or missing so action is needed
    merged == is_sorted
  end

  def flush
    if @property_flush[:ensure] == :absent
      delete_role
      return
    end

    update_role unless @property_flush.empty?
  end

  def update_role
    zbx.query(
      method: 'role.update',
      params: @property_flush.merge({ roleid: get_id(@resource[:name]) })
    )
  end

  def delete_role
    zbx.roles.delete(get_id(@resource[:name]))
  end

  def create
    params = {}
    params[:name] = @resource[:name]
    params[:type] = @resource[:type]
    params[:readonly] = @resource[:readonly] unless @resource[:readonly].nil?
    params[:rules] = @resource[:rules] unless @resource[:rules].nil?

    zbx.roles.create(params)
  end

  def exists?
    role
  end

  def destroy
    @property_flush[:ensure] = :absent
  end
end
