# frozen_string_literal: true

Facter.add(:zbx_admin_passwd_default) do
  confine kernel: 'Linux'
  setcode do
    require 'zabbixapi'
  rescue LoadError
    nil
  else
    def ini_parse(file)
      current_section = {}
      map = {}
      file.rewind
      file.each_line do |line|
        line = line.split(%r{^|\s;}).first # remove comments
        section = line.match(%r{^\s*\[([^\[\]]+)\]\s*$}) unless line.nil?
        if section
          current_section = section[1]
        elsif current_section
          item = line.match(%r{^\s*(.+?)\s*=\s*(.+?)\s*$}) unless line.nil?
          if item
            map[current_section] = map[current_section] || {}
            map[current_section][item[1]] = item[2]
          end
        end
      end
      map
    end

    def api_config
      @api_config ||= ini_parse(File.new('/etc/zabbix/api.conf'))
    end

    begin
      protocol = api_config['default']['apache_use_ssl'] == 'true' ? 'https' : 'http'
      zbx_check = ZabbixApi.connect(
        url: "#{protocol}://#{api_config['default']['zabbix_url']}/api_jsonrpc.php",
        user: api_config['default']['zabbix_user'],
        password: 'zabbix',
        http_user: api_config['default']['zabbix_user'],
        http_password: 'zabbix',
        ignore_version: true
      )
    rescue ZabbixApi::ApiError
      ret = false
    else
      ret = true
      zbx_check.query(method: 'user.logout', params: {})
    end
    ret
  end
end
