require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  # The CentOS docker image has a yum config that won't install docs, to keep used space low
  # zabbix packages their SQL file as doc, we need that for bootstrapping the database
  if host[:platform] =~ %r{el-7-x86_64} && host[:hypervisor] =~ %r{docker}
    on(host, "sed -i '/nodocs/d' /etc/yum.conf")
  end
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
