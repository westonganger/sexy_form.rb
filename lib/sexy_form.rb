require "sexy_form/version"
require "sexy_form/themes"
require "sexy_form/themes/*"
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

    str << %(<form #{self.build_html_attr_string(themed_form_html)}>)

    unless ["get", "post"].include?(method.to_s)
      str << %(<input type="hidden" name="_method" value="#{method}")
    end

    yield builder

    unless builder.html_string.empty?
      str << builder.html_string
    end

    str << "</form>"

    str
  end

  protected def self.build_html_attr_string(hash)
    hash.map{|k, v| "#{k}=\"#{v}\""}.join(" ")
  end

  protected def self.safe_string_hash(h)
    # TODO
    h.each_with_object(StringHash.new) do |(k, v), new_h|
      unless new_h.has_key?(k.to_s)
        if k.is_a?(String)
          new_h[k] = v.to_s
        elsif !h.has_key?(k.to_s)
          new_h[k.to_s] = v.to_s
        end
      end
    end
  end

end
