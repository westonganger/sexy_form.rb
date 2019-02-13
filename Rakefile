require File.expand_path(File.dirname(__FILE__) + '/lib/sexy_form/version')
require 'bundler/gem_tasks'

task :console do
  require 'sexy_form'

  require 'irb'
  binding.irb
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: :spec
task test: :spec
