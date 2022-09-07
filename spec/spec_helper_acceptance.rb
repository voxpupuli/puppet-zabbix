# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do
  # In Puppet 7 the locale ends up being C.UTF-8 if it isn't passed.
  # This locale doesn't exist in EL7 and won't be supported either.
  # At least PostgreSQL runs into this.
  ENV['LANG'] = 'en_US.UTF-8' if host['hypervisor'] == 'docker' && host['platform'] == 'el-7-x86_64'
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
