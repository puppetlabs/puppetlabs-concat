source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place, fake_version = nil)
  if place =~ /^(git:[^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

group :development, :unit_tests do
  gem 'rake',                    :require => false
  gem 'rspec-core', '3.1.7',     :require => false
  gem 'rspec-puppet', '~> 1.0',  :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'puppet-lint',             :require => false
  gem 'simplecov',               :require => false
  gem 'puppet_facts',            :require => false
  gem 'json',                    :require => false
end

beaker_rspec_version = ENV['BEAKER_RSPEC_VERSION']
group :system_tests do
  if beaker_rspec_version
    gem 'beaker-rspec', *location_for(beaker_rspec_version)
  else  
    gem 'beaker-rspec',  :require => false
  end
  gem 'serverspec',    :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', *location_for(facterversion)
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', *location_for(puppetversion)
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
