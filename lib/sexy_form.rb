require "sexy_form/version"
require "sexy_form/themes"

### Require all themes
Dir[File.join(__dir__, "sexy_form/themes/*.rb")].each do |f| 
  require "sexy_form/themes/#{f.split("/").last}"
end

require "sexy_form/builder"

module SexyForm
  def self.form(action: nil, method: "post", theme: nil, form_html: {}, &block)
    action = action.to_s
    method = method.to_s

    builder = SexyForm::Builder.new(theme: theme)

    themed_form_html = builder.theme.form_html_attributes(self.safe_string_hash(form_html))

    themed_form_html["method"] = method.to_s == "get" ? "get" : "post"

    if themed_form_html["multipart"] == true
      themed_form_html.delete("multipart")
      themed_form_html["enctype"] = "multipart/form-data"
    end

    str = ""

    str << %Q(<form #{self.build_html_attr_string(themed_form_html)}>)

    unless ["get", "post"].include?(method.to_s)
      str << %Q(<input type="hidden" name="_method" value="#{method}")
    end

    yield builder

    unless builder.html_string.empty?
      str << builder.html_string
    end

    str << "</form>"

    str
  end

  protected

  def self.build_html_attr_string(hash)
    hash.map{|k, v| "#{k}=\"#{v}\""}.join(" ")
  end

  def self.safe_string_hash(h)
    # TODO
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

  ### END PROTECTED METHODS

end
