require File.expand_path(File.dirname(__FILE__) + '/lib/sexy_form/version')
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: :spec
task test: :spec

task :console do
  require_relative 'test/test_helper'

  require 'irb'
  binding.irb
end
