module FormBuilder
  class Builder
    FIELD_TYPES = {"checkbox", "file", "hidden", "password", "radio", "select", "text", "textarea"}
    INPUT_TYPES = FIELD_TYPES - {"select","textarea"}

    def initialize(theme : (String | Symbol)? = nil, form_type : (String | Symbol)? = nil, @errors : Hash(String, Array(String))? = nil)
      if theme
        @theme = Themes.subclasses.find do |klass|
          name = klass.name.to_s.split("::").last.underscore

          i = name.index(/\d/)

          if i
            name = name.insert(i, "_")
          end

          if name == theme.to_s
            klass.new
          end
        end || raise("FormBuilder theme '#{theme}' was not found")
      end
    end

    def field(type : (String | Symbol), name : (String | Symbol), value : (String | Symbol)? = nil, input_html : OptionHash, label_html : OptionHash = OptionHash.new, = OptionHash.new wrapper_html : OptionHash = OptionHash.new, **options : Object)
      unless FIELD_TYPES.includes?(type.to_s)
        raise "Invalid Field :type, valid Types are `#{FIELD_TYPES.join(", ")}`"
      end

      if label_content != false
        label_proc = -> {
          FormBuilder.content(element_name: :label, content: (options[:label]? || name.to_s.capitalize), options: label_html)
        }
      end

      input_opts = Kit.safe_hash({:name => name, :id => name}, input_html)

      case type.to_s
      when "checkbox"
        ### Allow passing checked=true/false
        if input_opts[:checked]?
          input_opts[:checked] = "checked"
        else
          input_opts.delete(:checked)
        end

        field_html = input(type: type, options: input_opts)

      when "file"
        field_html = input(type: type, options: input_opts.reject(:type))
      when "hidden"
        field_html = input(type: type, options: input_opts)
      when "password"
        field_html = input(type: type, options: input_opts.reject(:type))
      when "radio"
        input_opts = Kit.safe_hash({:value => checked_value}, option_hash)

        ### Allow passing checked=true/false
        if input_opts[:checked]?
          input_opts[:checked] = "checked"
        else
          input_opts.delete(:checked)
        end

        field_html = input(type: type, options: input_opts)

      when "select"
        unless options[:collection]?
          raise "Must provide the `:collection` when using `type: :select`"
        end

        field_html = select(name: name, collection: options[:collection], disabled: options[:disabled]?, selected: options[:selected]?, options: input_opts)
      when "text"
        field_html = input(type: type, options: input_opts)
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

      @theme.wrap_field(field_type: type, form_type: @form_type, label_proc: label_proc, field_proc: field_proc, errors: @errors[name]?, wrapper_html: wrapper_html)
    end

    private def input(type : INPUT_TYPES, options : OptionHash)
      options.delete(:type)

      options[:id] = options[:name] if (options[:name]?) && !(options[:id]?)

      boolean_attributes = {:disabled}

      boolean_options = options.select(boolean_attributes)
      tag_options = options.reject!(boolean_attributes).map{ |k, v| "#{k}=\"#{v}\"" }
      tag_options = tag_options << boolean_options.keys.join(" ") if !boolean_options.empty?

      "<input type=\"#{type}\" #{tag_options.join(" ")}/>"
    end

    private def select(name : (String | Symbol), collection : (Array(Array) | Array | Range), selected : Array(String), disabled : Array(String), **options : Object)
      unless collection.is_a?(Array(Array)) 
        collection.map{|x| [x.to_s, x.to_s.capitalize] }
      end

      options_hash = Kit.safe_hash(options, {:name => name})

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

  end
end
