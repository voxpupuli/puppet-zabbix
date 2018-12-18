# zabbix provider type for puppet
class Puppet::Provider::Zabbix < Puppet::Provider
  # This method is vendored from the AWS SDK, rather than including an
  # extra library just to parse an ini file
  # Copied from https://github.com/puppetlabs/puppetlabs-aws/blob/2d34b1602bdd564b3f882f683dc000878f539343/lib/puppet_x/puppetlabs/aws.rb#L120
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

  def zbx
    @zbx ||= create_connection
  end

  # Create the api connection
  def create_connection
    protocol = api_config['default']['apache_use_ssl'] == 'true' ? 'https' : 'http'
    zbx = ZabbixApi.connect(
      url: "#{protocol}://#{api_config['default']['zabbix_url']}/api_jsonrpc.php",
      user: api_config['default']['zabbix_user'],
      password: api_config['default']['zabbix_pass'],
      http_user: api_config['default']['zabbix_user'],
      http_password: api_config['default']['zabbix_pass']
    )
    zbx
  end

  # Check if host exists. When error raised, return false.
  def check_host(host)
    zbx.query(
      method: 'host.get',
      params: {
        filter: {
          'host' => [host]
        },
        selectParentTemplates: ['host'],
        output: ['host']
      }
    )
  rescue Puppet::ExecutionFailure
    false
  end

  # Check if proxy exists. When error raised, return false.
  def check_proxy(host)
    zbx.proxies.get_id(host: host)
  rescue Puppet::ExecutionFailure
    false
  end

  # Get the template id from the name.
  def get_template_id(zbx, template)
    return template if a_number?(template)
    zbx.templates.get_id(host: template)
  end

  # Check if given template name exists in current host.
  def check_template_in_host(host)
    template_id = get_template_id(zbx, template)
    template_array = zbx.templates.get_ids_by_host(hostids: [zbx.hosts.get_id(host: host)])
    template_array.include?(template_id.to_s)
  end

  # Is it a number?
  def a_number?(s)
    s.to_s.match(%r{\A[+-]?\d+?(\.\d+)?\Z}).nil? ? false : true
  end
end
