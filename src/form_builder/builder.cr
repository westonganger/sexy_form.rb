module FormBuilder
  class Builder
    FIELD_TYPES = {"checkbox", "file", "hidden", "password", "radio", "select", "text", "textarea"}
    INPUT_TYPES = Tuple(String).from(FIELD_TYPES.to_a - ["select", "textarea"])
    
    @theme : FormBuilder::Themes?

    def initialize(theme : (String | Symbol)? = nil, @errors : Hash(String, Array(String))? = nil)
      if theme
        @theme = Themes.from_name(theme).new
      end
    end

    def field(type : (String | Symbol), name : (String | Symbol), value : (String | Symbol)? = nil, label : (Bool | String | Symbol)? = nil, input_html : OptionHash = OptionHash.new, label_html : OptionHash = OptionHash.new, wrapper_html : OptionHash = OptionHash.new, collection : (Array(Array) | Array | Range)? = nil, selected : Array(String)? = nil, disabled : Array(String)? = nil)
      unless FIELD_TYPES.includes?(type.to_s)
        raise ArgumentError.new("Invalid :type argument, valid field types are: #{FIELD_TYPES.join(", ")}`")
      end

      if ["checkbox", "radio"].includes?(type.to_s)
        ### Allow passing checked=true/false

        if input_html[:checked]? == true
          input_html[:checked] = "checked"
        elsif input_html[:checked]? == false
          input_html.delete(:checked)
        end
      end

      if type.to_s != "select"
        if collection
          raise ArgumentError.new("Invalid :collection argument passed for field type: #{type}, :collection is only allowed with field type: :select")
        elsif selected
          raise ArgumentError.new("Invalid :selected argument passed for field type: #{type}, :selected is only allowed with field type: :select")
        elsif disabled
          raise ArgumentError.new("Invalid :disabled argument passed for field type: #{type}, :disabled is only allowed with field type: :select")
        end
      end

      if INPUT_TYPES.includes?(type.to_s)
        input_html[:value] ||= value
      end

      if label != false
        label_str = "#{label == true ? name.to_s.capitalize : label}"

        if !label_str && !label_str.empty?
          label_proc = -> {
            FormBuilder.content(element_name: :label, content: label_str, options: label_html)
          }
        end
      end

      css_safe_name = css_safe(name)

      unless input_html[:id]?
        input_html[:id] = css_safe_name
      end

      unless input_html[:name]?
        input_html[:name] = css_safe_name
      end

      case type.to_s
      when "checkbox"
        field_html = input_field(type: type, options: input_html)
      when "file"
        field_html = input_field(type: type, options: input_html.reject(:type))
      when "hidden"
        field_html = input_field(type: type, options: input_html)
      when "password"
        field_html = input_field(type: type, options: input_html.reject(:type))
      when "radio"
        field_html = input_field(type: type, options: input_html)
      when "select"
        if collection.nil?
          raise ArgumentError.new("Required argument `:collection` not provided while using `type: :select`")
        else
          if value && selected
            raise ArgumentError.new("Cannot provide `:value` and `:selected` arguments together. The `:selected` argument is recommended for field `type: :select.`")
          end

          field_html = select_field(collection: collection, selected: (selected || value), disabled: disabled, options: input_html)
        end
      when "text"
        field_html = input_field(type: type, options: input_html)
      when "textarea"
        if input_html.has_key?(:size)
          input_html[:cols], input_html[:rows] = input_html.delete(:size).to_s.split("x")
        end

        field_html = FormBuilder.content(element_name: type, content: (input_html[:value]? ? input_html[:value].to_s : value.to_s), options: input_html)
      end

      field_proc : Proc(String) = -> {
        field_html.to_s
      }

      if (errors = @errors)
        field_errors = errors[name]?
      end

      if (theme = @theme)
        theme.wrap_field(field_type: type.to_s, label_proc: label_proc, field_proc: field_proc, field_errors: field_errors, wrapper_html: wrapper_html)
      else
        "#{label_proc.call if label_proc}#{field_proc.call}"
      end
    end

    private def input_field(type : (String | Symbol), options : OptionHash? = OptionHash.new)
      unless INPUT_TYPES.includes?(type.to_s)
        raise ArgumentError.new("Invalid input :type, valid input types are `#{INPUT_TYPES.join(", ")}`")
      end

      options.delete(:type)

      boolean_attributes = {:disabled}

      boolean_options = options.select(boolean_attributes)
      tag_options = options.reject!(boolean_attributes).map{ |k, v| "#{k}=\"#{v}\"" }
      tag_options = tag_options << boolean_options.keys.join(" ") if !boolean_options.empty?

      "<input type=\"#{type}\" #{tag_options.join(" ")}/>"
    end

    private def select_field(collection : (Array(Array) | Array | Range), selected : Array(String)? = [] of String, disabled : Array(String)? = [] of String, options : OptionHash? = OptionHash.new)
      unless collection.first.is_a?(Array) 
        collection.map{|x| [x.to_s, x.to_s.capitalize] }
      end

      FormBuilder.content(element_name: :select, options: options) do
        String.build do |str|
          collection.map do |x|
            str << "<option value=\"#{x[0]}\""
            str << "#{" selected=\"selected\"" if selected.includes?(x[0].to_s)}"
            str << "#{" disabled=\"disabled\"" if disabled.includes?(x[0].to_s)}"
            str << ">#{x[1]}</option>"
          end
        end
      end
    end

    private def css_safe(value)
      values = value.to_s.strip.split(' ')
      values.map{|v| v.gsub(/[^\w-]+/, " ").strip.gsub(/\s+/, "_") }.join(' ')
    end

  end
end
