require 'rake'
require 'rspec/core/rake_task'

task :default => [:spec]

desc "Run all module spec tests (Requires rspec-puppet gem)"
RSpec::Core::RakeTask.new(:spec)

desc "Build package"
task :build do
  system("puppet-module build")
end

