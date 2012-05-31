require 'puppet'
require 'rspec'
require 'rspec-puppet'

RSpec.configure do |c|
  c.module_path = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/modules/'))
  # Using an empty site.pp file to avoid: https://github.com/rodjek/rspec-puppet/issues/15
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/manifests'))
end
