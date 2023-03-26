require "sexy_form/version"
require "sexy_form/themes"

### Require all themes
require "sexy_form/themes/base_theme"
Dir[File.join(__dir__, "sexy_form/themes/*.rb")].each do |f|
  require "sexy_form/themes/#{f.split("/").last}"
end

require "sexy_form/builder"
require "sexy_form/action_view_helpers"

module SexyForm
  protected

  def self.build_html_attr_string(hash)
    hash.delete_if{|_,v| v.nil? || v.to_s.strip.empty? }.map{|k, v| "#{k}=\"#{v.to_s.strip}\""}.join(" ")
  end

  def self.build_html_element(type, hash)
    attr_str = build_html_attr_string(hash)
    attr_str.empty? ? "<#{type}>" : "<#{type} #{attr_str}>"
  end

  def self.safe_string_hash(h)
    new_h = {}
    h.each do |k, v|
      unless new_h.has_key?(k.to_s)
        if k.is_a?(String)
          new_h[k] = v
        elsif !h.has_key?(k.to_s)
          new_h[k.to_s] = v
        end
      end
    end
    new_h
  end

  def self.verify_argument_type(arg_name:, value:, expected_type:)
    if expected_type.is_a?(Array)
      invalid = expected_type.all?{|t| !value.is_a?(t) }
    elsif !value.is_a?(expected_type)
      invalid = true
    end

    if invalid
      raise ArgumentError.new("Invalid type passed to argument :#{arg_name}")
    end
  end
end
