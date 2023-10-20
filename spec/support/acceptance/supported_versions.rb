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
