source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  gem 'rake',                    :require => true
  gem 'rspec-puppet',            :require => true
  gem 'puppetlabs_spec_helper',  :require => true
  gem 'serverspec',              :require => false
  gem 'puppet-lint',             :require => false
  gem 'beaker',                  :require => false
  gem 'beaker-rspec',            :require => false
  gem 'pry',                     :require => false
  gem 'simplecov',               :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

gem 'puppet', '<4.0.0', :require => false
