require "sexy_form"

require 'custom_assertions'

RSpec.configure do |config|
  config.expect_with(:rspec) do |c|
    c.syntax = [:should, :expect]
  end
end

### Easier than rewriting all the Crystal String.build calls in spec folder
def self.build_string(&block)
  s = ""
  block.call(s)
  return s
end
