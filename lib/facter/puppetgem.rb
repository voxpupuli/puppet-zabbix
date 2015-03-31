# Get the pe_gem or gem var back

Facter.add(:puppetgem) do
  setcode do
    if File.exist?('/etc/puppetlabs/puppet/puppet.conf')
      'pe_gem'
    else
      'gem'
    end
  end
end

