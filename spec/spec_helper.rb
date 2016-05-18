require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

def mocked_facts
  {
    concat_basedir: '/tmp',
    is_pe: false,
    selinux_config_mode: 'disabled'
  }
end
