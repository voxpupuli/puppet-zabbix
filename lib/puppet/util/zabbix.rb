# this module adds additional params to a puppet type
module Puppet::Util::Zabbix
  def self.add_zabbix_type_methods(type)
    type.newparam(:zabbix_url) do
      desc 'The url on which the zabbix-api is available.'
    end

    type.newparam(:zabbix_user) do
      desc 'Zabbix-api username.'
    end

    type.newparam(:zabbix_pass) do
      desc 'Zabbix-api password.'
    end

    type.newparam(:apache_use_ssl) do
      desc 'If apache is uses with ssl'
    end
  end
end
