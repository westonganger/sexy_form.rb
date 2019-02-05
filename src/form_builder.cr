require "./form_builder/version"
require "./form_builder/themes"
require "./form_builder/themes/*"
require "./form_builder/builder"

module FormBuilder
  alias OptionHash = Hash((Symbol | String), (Nil | String | Symbol | Bool | Int8 | Int16 | Int32 | Int64 | Float32 | Float64 | Time | Bytes | Array(String) | Array(Int32) | Array(String | Int32)))

  def self.form(
    action : String? = nil,
    method : (String | Symbol)? = :post,
    theme : (String | Symbol)? = nil, 
    errors : Hash(String, Array(String))? = nil, 
    form_html : (NamedTuple | OptionHash)? = OptionHash.new, 
    &block
  ) : String
    form_attrs = (form_html.is_a?(NamedTuple) ? form_html.to_h : form_html).reject{|k,v| k.is_a?(Symbol) && form_html.keys.includes?(k.to_s)}

    form_attrs[:method] = method.to_s == "get" ? "get" : "post"

    if form_attrs[:multipart]? == true
      form_attrs.delete(:multipart)
      form_attrs[:enctype] = "multipart/form-data"
    end

    builder = FormBuilder::Builder.new(theme: theme, errors: errors)

    content(element_name: :form, options: form_attrs) do
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
    errors : Hash(String, Array(String))? = nil, 
    form_html : (NamedTuple | OptionHash)? = OptionHash.new
  ) : String
    form(action: action, method: method, theme: theme, errors: errors, form_html: form_html) do; end
  end

  protected def self.content(element_name : Symbol, options : OptionHash, &block)
    String.build do |str|
      str << "<#{element_name}"
      options.each do |k, v|
        next if v.nil?
        str << %( #{k}="#{v}")
      end
      str << ">#{yield}</#{element_name}>"
    end
  end

end
