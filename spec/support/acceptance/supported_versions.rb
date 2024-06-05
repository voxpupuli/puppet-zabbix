# frozen_string_literal: true

def supported_versions
  supported_versions = %w[5.0 6.0]
  # this is a hack so that we don't have to rewrite the existing acceptance tests
  if (beaker_zabbix_version = ENV.fetch('BEAKER_FACTER_zabbix_version', nil))
    supported_versions &= [beaker_zabbix_version]
    raise "Unsupported version: #{beaker_zabbix_version}" if supported_versions.empty?
  end
  supported_versions
end

def supported_agent_versions(platform)
  supported_versions.reject do |version|
    version < '6.0' && platform.start_with?('debian-12')
  end
end

def supported_server_versions(platform)
  supported_versions.reject do |version|
    platform.start_with?('archlinux') ||
      (version >= '5.2' && platform.start_with?('el-7')) ||
      (version < '6.0' && platform.start_with?('el-9', 'ubuntu-22', 'debian-12'))
  end
end

def supported_proxy_versions(platform)
  supported_versions.reject do |version|
    platform.start_with?('archlinux', 'el7', 'el8') ||
      (version < '6.0' && platform.start_with?('el-9', 'debian-12'))
  end
end
