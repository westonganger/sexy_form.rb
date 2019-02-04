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
    form_html : (NamedTuple | Hash)? = OptionHash.new, 
    &block
  ) : String
    html = form_html.is_a?(NamedTuple) ? form_html.to_h : form_html

    html[:method] = method.to_s == "get" ? "get" : "post"

    if html[:multipart]? == true
      html[:enctype] = "multipart/form-data"
    end

    builder = FormBuilder::Builder.new(theme: theme, errors: errors)

    content(element_name: :form, options: html) do
      String.build do |str|
        unless ["get", "post"].includes?(method.to_s)
          str << %(<input type="hidden" name="_method" value="#{method}")
        end

        str << yield builder
      end
    end
  end

  ### Overload for optional &block
  def self.form(
    action : String? = nil, 
    method : (String | Symbol)? = :post, 
    theme : (String | Symbol)? = nil, 
    errors : Hash(String, Array(String))? = nil, 
    form_html : (NamedTuple | Hash)? = OptionHash.new
  ) : String
    form(action: action, method: method, theme: theme, errors: errors, form_html: form_html) do; end
  end

  protected def self.content(element_name : Symbol, options : OptionHash, &block) : String
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
