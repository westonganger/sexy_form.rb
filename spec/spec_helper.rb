require "sexy_form"

require 'custom_assertions'

RSpec.configure do |config|
  config.expect_with(:rspec) do |c|
    c.syntax = [:should, :expect]
  end
end

### Easier than rewriting all the Crystal String.build calls in spec folder
def build_string(&block)
  s = ""
  block.call(s)
  return s
end

TESTED_FIELD_TYPES = ["checkbox", "file", "hidden", "password", "radio", "select", "text", "textarea", "date", "datetime-local", "time"].freeze
