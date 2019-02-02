require "./form_builder/themes"
require "./form_builder/themes/*"
require "./form_builder/builder"

module FormBuilder
  alias OptionHash = Hash((Symbol | String), (Nil | String | Symbol | Bool | Int8 | Int16 | Int32 | Int64 | Float32 | Float64 | Time | Bytes | Array(String) | Array(Int32) | Array(String | Int32)))

  def self.form(action : String? = nil, method : (String | Symbol)? = :post, theme : (String | Symbol)? = nil, errors : Hash(String, Array(String))? = nil, options : OptionHash = OptionHash.new, &block)
    options_hash[:method] = method == :get ? :get : :post

    if options_hash[:multipart]? == true
      options_hash[:enctype] = "multipart/form-data"
    end

    builder = FormBuilder::Builder.new(theme: theme, errors: errors)

    content(element_name: :form, options: options_hash) do
      String.build do |str|
        str << builder.input(type: :hidden, name: "_method", value: method) unless [:get, :post].includes?(method)

        str << yield builder
      end
    end
  end

  ### Overloads Start
  def self.form(action : String? = nil, method : (String | Symbol)? = :post, theme : (String | Symbol)? = nil, errors : Hash(String, Array(String))? = nil, **options : Object, &block)
    options_hash : OptionHash = options.to_h.as(OptionHash) ### TODO: is this working?
    form(action: action, method: method, theme: theme, errors: errors, options: options, &block)
  end

  ### Overloads for optional **options and block
  def self.form(action : String? = nil, method : (String | Symbol)? = :post, theme : (String | Symbol)? = nil, errors : Hash(String, Array(String))? = nil, &block)
    form(action: action, method: method, theme: theme, errors: errors, options: OptionHash.new) do; end
  end

  def self.form(action : String? = nil, method : (String | Symbol)? = :post, theme : (String | Symbol)? = nil, errors : Hash(String, Array(String))? = nil)
    form(action: action, method: method, theme: theme, errors: errors, options: OptionHash.new) do; end
  end

  def self.form(action : String? = nil, method : (String | Symbol)? = :post, theme : (String | Symbol)? = nil, errors : Hash(String, Array(String))? = nil, **options : Object)
    options_hash : OptionHash = options.to_h.as(OptionHash) ### TODO: is this working?
    form(action: action, method: method, theme: theme, errors: errors, options: options_hash) do; end
  end
  ### END Overloads

  protected def self.content(element_name : Symbol, content : String, options : OptionHash)
    content(element_name: element_name, options: options) do
      content
    end
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
