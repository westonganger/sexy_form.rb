lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sexy_form/version'

Gem::Specification.new do |s|
  s.name        = 'sexy_form'
  s.version     =  SexyForm::VERSION
  s.author	= "Weston Ganger"
  s.email       = 'weston@westonganger.com'
  s.homepage 	= 'https://github.com/westonganger/sexy_form'

  s.summary     = "Dead simple HTML form builder for Ruby with built-in support for many popular UI libraries such as Bootstrap"

  s.description = s.summary

  s.files = Dir.glob("{lib/**/*}") + %w{ LICENSE README.md Rakefile CHANGELOG.md }
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'actionview'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
end
