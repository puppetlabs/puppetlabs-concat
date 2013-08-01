require 'bundler'
Bundler.require(:rake)
require 'rake/clean'

CLEAN.include('doc', 'pkg')

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet_blacksmith/rake_tasks'

task :default => [:clean, :spec]
