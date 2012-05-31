require 'puppet'
require 'rspec'
require 'rspec-puppet'

#def param_value(subject, type, title, param)
#  subject.resource(type, title).send(:parameters)[param.to_sym]
#end
#
#def verify_contents(subject, title, expected_lines)
#  content = subject.resource('file', title).send(:parameters)[:content]
#  (content.split("\n") & expected_lines).should == expected_lines
#end

RSpec.configure do |c|
  c.module_path = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/modules/'))
  # Using an empty site.pp file to avoid: https://github.com/rodjek/rspec-puppet/issues/15
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures/manifests'))
end
