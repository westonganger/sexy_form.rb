module FormBuilder::Tags
  def content(element_name : Symbol, content : String, options : OptionHash)
    content(element_name: element_name, options: options) do
      content
    end
  end

  def content(element_name : Symbol, options : OptionHash, &block)
    String.build do |str|
      str << "<#{element_name}"
      options.each do |k, v|
        next if v.nil?
        str << %( #{k}="#{v}")
      end
      str << ">#{yield}</#{element_name}>"
    end
  end

  # INPUT_BOOLEAN_ATTRIBUTES = [:disabled]

  # def input_field(type : Symbol, **options)
  #   options = options.to_h
  #   input_field_string(type: type, options: options)
  # end

  # def input_field(type : Symbol, options : OptionHash)
  #   input_field_string(type: type, options: options)
  # end

  # def input_field_string(type : Symbol, options : OptionHash)
  #   tag_options = prepare_input_field_options(options: options)
  #   "<input type=\"#{type}\" #{tag_options}/>"
  # end

  # # helper for input field options
  # def prepare_input_field_options(options : OptionHash)
  #   options[:id] = options[:name] if (options[:name]?) && !(options[:id]?)
  #   boolean_options = options.select(INPUT_BOOLEAN_ATTRIBUTES)
  #   tag_options = options.reject!(INPUT_BOOLEAN_ATTRIBUTES).map { |k, v| "#{k}=\"#{v}\"" }
  #   tag_options = tag_options << boolean_options.keys.join(" ") if !boolean_options.empty?
  #   tag_options = tag_options.join(" ")
  #   tag_options
  # end

  # def content(element_name : Symbol, content : String, options : OptionHash)
  #   content(element_name: element_name, options: options) do
  #     content
  #   end
  # end

  # def content(element_name : Symbol, options : OptionHash, &block)
  #   String.build do |str|
  #     str << "<#{element_name}"
  #     options.each do |k, v|
  #       next if v.nil?
  #       str << %( #{k}="#{v}")
  #     end
  #     str << ">#{yield}</#{element_name}>"
  #   end
  # end

end
