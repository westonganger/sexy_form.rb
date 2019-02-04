module FormBuilder
  class Builder
    FIELD_TYPES = {"checkbox", "file", "hidden", "password", "radio", "select", "text", "textarea"}
    INPUT_TYPES = FIELD_TYPES - {"select","textarea"}
    
    @theme : FormBuilder::Themes?

    def initialize(theme : (String | Symbol)? = nil, @errors : Hash(String, Array(String))? = nil)
      if theme
        @theme = Themes.from_name(theme).new
      end
    end

    def field(type : (String | Symbol), name : (String | Symbol), value : (String | Symbol)? = nil, input_html : OptionHash = OptionHash.new, label_html : OptionHash = OptionHash.new, wrapper_html : OptionHash = OptionHash.new, **options : Object)
      unless FIELD_TYPES.includes?(type.to_s)
        raise "Invalid Field :type, valid Types are `#{FIELD_TYPES.join(", ")}`"
      end

      if label_content != false
        label_proc = -> {
          FormBuilder.content(element_name: :label, content: (options[:label]? || name.to_s.capitalize), options: label_html)
        }
      end

      unless input_html[:id]?
        input_html[:id] = css_safe(name)
      end

      case type.to_s
      when "checkbox"
        ### Allow passing checked=true/false
        if input_opts[:checked]?
          input_opts[:checked] = "checked"
        else
          input_opts.delete(:checked)
        end

        field_html = input(name: name, type: type, options: input_opts)

      when "file"
        field_html = input(name: name, type: type, options: input_opts.reject(:type))
      when "hidden"
        field_html = input(name: name, type: type, options: input_opts)
      when "password"
        field_html = input(name: name, type: type, options: input_opts.reject(:type))
      when "radio"
        # TODO

        ### Allow passing checked=true/false
        if input_opts[:checked]?
          input_opts[:checked] = "checked"
        else
          input_opts.delete(:checked)
        end

        field_html = input(name: name, type: type, options: input_opts)

      when "select"
        unless options[:collection]?
          raise "Must provide the `:collection` when using `type: :select`"
        end

        field_html = select_field(name: name, collection: options[:collection], disabled: options[:disabled]?, selected: options[:selected]?, options: input_opts)
      when "text"
        field_html = input(name: name, type: type, options: input_opts)
      when "textarea"
        if options.has_key?(:size)
          input_opts[:cols], input_opts[:rows] = input_opts.delete(:size).to_s.split("x")
        end

        if options.has_key?(:value)
          val = input_opts.delete(:value)
        end

        field_html = FormBuilder.content(element_name: type, content: content, options: input_opts)
      end

      field_proc = -> {
        field_html
      }

      @theme.wrap_field(field_type: type, label_proc: label_proc, field_proc: field_proc, errors: @errors[name]?, wrapper_html: wrapper_html)
    end

    private def input(name : (String | Symbol), type : INPUT_TYPES, options : OptionHash)
      options.delete(:type)

      boolean_attributes = {:disabled}

      boolean_options = options.select(boolean_attributes)
      tag_options = options.reject!(boolean_attributes).map{ |k, v| "#{k}=\"#{v}\"" }
      tag_options = tag_options << boolean_options.keys.join(" ") if !boolean_options.empty?

      "<input name=\"#{options[:name]? ? options.delete(:name) : name}\" type=\"#{type}\" #{tag_options.join(" ")}/>"
    end

    private def select_field(name : (String | Symbol), collection : (Array(Array) | Array | Range), selected : Array(String), disabled : Array(String), **options : Object)
      unless collection.is_a?(Array(Array)) 
        collection.map{|x| [x.to_s, x.to_s.capitalize] }
      end

      unless options[:name]?
        options_hash[:name] = name
      end

      FormBuilder.content(element_name: :select, options: options_hash) do
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

    private def css_safe(str)
      values = value.to_s.strip.split(' ')
      values.map { |v| v.gsub(/[^\w-]+/, " ").strip.gsub(/\s+/, "_") }.join(' ')
    end

  end
end
