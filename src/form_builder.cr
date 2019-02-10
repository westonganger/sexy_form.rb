require "./form_builder/version"
require "./form_builder/themes"
require "./form_builder/themes/*"
require "./form_builder/builder"

module FormBuilder
  alias OptionHash = Hash((Symbol | String), (Nil | String | Symbol | Bool | Int8 | Int16 | Int32 | Int64 | Float32 | Float64 | Time | Bytes | Array(String) | Array(Int32) | Array(String | Int32)))
  alias StringOptionHash = Hash(String, (Nil | String | Symbol | Bool | Int8 | Int16 | Int32 | Int64 | Float32 | Float64 | Time | Bytes | Array(String) | Array(Int32) | Array(String | Int32)))
  alias StringHash = Hash(String, String)

  def self.form(
    action : String? = nil,
    method : (String | Symbol)? = :post,
    theme : (String | Symbol | FormBuilder::Themes)? = nil,
    form_html : (NamedTuple | OptionHash)? = OptionHash.new,
    &block
  ) : String
    builder = FormBuilder::Builder.new(theme: theme)

    themed_form_html = builder.theme.form_html_attributes(html_attrs: self.safe_string_hash(form_html.is_a?(NamedTuple) ? form_html.to_h : form_html))

    themed_form_html["method"] = method.to_s == "get" ? "get" : "post"

    if themed_form_html["multipart"]? == "true"
      themed_form_html.delete("multipart")
      themed_form_html["enctype"] = "multipart/form-data"
    end

    content(element_name: "form", attrs: themed_form_html) do
      String.build do |str|
        unless ["get", "post"].includes?(method.to_s)
          str << %(<input type="hidden" name="_method" value="#{method}")
        end

        yield builder

        unless builder.html_string.empty?
          str << builder.html_string
        end
      end
    end
  end

  ### Overload for optional &block
  def self.form(
    action : String? = nil,
    method : (String | Symbol)? = :post,
    theme : (String | Symbol)? = nil,
    form_html : (NamedTuple | OptionHash)? = OptionHash.new
  ) : String
    form(action: action, method: method, theme: theme, form_html: form_html) do; end
  end

  protected def self.content(element_name : String, attrs : StringHash, &block)
    String.build do |str|
      str << "<#{element_name}"
      attrs.each do |k, v|
        next if v.nil?
        str << %( #{k}="#{v}")
      end
      str << ">#{yield}</#{element_name}>"
    end
  end

  protected def self.safe_string_hash(h : Hash)
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

  protected def self.safe_stringify_hash_keys(h : Hash)
    h.each_with_object(StringOptionHash.new) do |(k, v), new_h|
      unless new_h.has_key?(k.to_s)
        if k.is_a?(String)
          new_h[k] = v
        elsif !h.has_key?(k.to_s)
          new_h[k.to_s] = v
        end
      end
    end
  end

end
