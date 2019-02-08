module FormBuilder
  class Builder
    private FIELD_TYPES = {"checkbox", "file", "hidden", "password", "radio", "select", "text", "textarea"}
    private INPUT_TYPES = FIELD_TYPES.to_a - ["select", "textarea"]

    @theme : FormBuilder::Themes
    @html : Array(String) = [] of String

    def initialize(theme : (String | Symbol)? = nil, @errors : Hash(String, Array(String))? = nil)
      if theme
        @theme = Themes.from_name(theme.to_s).new
      else
        @theme = FormBuilder::Themes::Default.new
      end
    end

    def <<(value)
      @html.push(value.to_s)
    end

    def theme
      @theme
    end

    def html_string
      @html.join("")
    end

    def field(
      type : (String | Symbol),
      name : (String | Symbol)? = nil,
      value : (String | Symbol)? = nil,
      label : (Bool | String | Symbol)? = nil,
      input_html : (NamedTuple | OptionHash) = OptionHash.new,
      label_html : (NamedTuple | OptionHash) = OptionHash.new,
      wrapper_html : (NamedTuple | OptionHash) = OptionHash.new,
      collection : (Array(Array) | Array | Range | String)? = nil,
      selected : Array(String)? = nil,
      disabled : Array(String)? = nil
    )
      type_str = type.to_s

      unless FIELD_TYPES.includes?(type_str)
        raise ArgumentError.new("Invalid :type argument, valid field types are: #{FIELD_TYPES.join(", ")}`")
      end

      if type_str != "select"
        if collection
          raise ArgumentError.new("Invalid :collection argument passed for field type: #{type_str}, :collection is only allowed with field type: :select")
        elsif selected
          raise ArgumentError.new("Invalid :selected argument passed for field type: #{type_str}, :selected is only allowed with field type: :select")
        elsif disabled
          raise ArgumentError.new("Invalid :disabled argument passed for field type: #{type_str}, :disabled is only allowed with field type: :select")
        end
      end

      if label != false
        if label == true
          label_text = name.to_s.capitalize if name
        else
          label_text = label.to_s
        end
      end

      themed_input_html = @theme.input_html_attributes(html_attrs: FormBuilder.safe_string_hash(input_html.is_a?(NamedTuple) ? input_html.to_h : input_html), field_type: type_str, name: name.to_s, label_text: label_text)

      themed_label_html = @theme.label_html_attributes(html_attrs: FormBuilder.safe_string_hash(label_html.is_a?(NamedTuple) ? label_html.to_h : label_html), field_type: type_str, name: name.to_s, label_text: label_text)

      if ["checkbox", "radio"].includes?(type_str)
        ### Allow passing checked=true/false

        if themed_input_html["checked"]? == "true"
          themed_input_html["checked"] = "checked"
        elsif themed_input_html["checked"]? == "false"
          themed_input_html.delete("checked")
        end
      end

      if !themed_input_html["value"]? && !value.to_s.empty? && INPUT_TYPES.includes?(type_str)
        themed_input_html["value"] = value.to_s
      end

      if name
        css_safe_name = css_safe(name)

        unless themed_input_html.has_key?("id")
          themed_input_html["id"] = css_safe_name
        end

        unless themed_input_html.has_key?("name")
          themed_input_html["name"] = css_safe_name
        end
      end

      case type_str
      when "checkbox"
        html_field = input_field(type: type_str, options: themed_input_html)
      when "file"
        html_field = input_field(type: type_str, options: themed_input_html)
      when "hidden"
        html_field = input_field(type: type_str, options: themed_input_html)
      when "password"
        html_field = input_field(type: type_str, options: themed_input_html)
      when "radio"
        html_field = input_field(type: type_str, options: themed_input_html)
      when "select"
        if collection.nil?
          raise ArgumentError.new("Required argument `:collection` not provided while using `type: :select`")
        else
          if value && selected
            raise ArgumentError.new("Cannot provide `:value` and `:selected` arguments together. The `:selected` argument is recommended for field `type: :select.`")
          end

          html_field = select_field(collection: collection, selected: (selected || value), disabled: disabled, options: themed_input_html)
        end
      when "text"
        html_field = input_field(type: type_str, options: themed_input_html)
      when "textarea"
        if themed_input_html.has_key?("size")
          themed_input_html["cols"], themed_input_html["rows"] = themed_input_html.delete("size").to_s.split("x")
        end

        html_field = FormBuilder.content(element_name: type_str, options: themed_input_html) do
          themed_input_html["value"]?
        end
      end

      if label_text
        html_label = FormBuilder.content(element_name: "label", options: themed_label_html) do
          label_text
        end
      end

      if name && (errors = @errors)
        field_errors = errors[name]?
      end

      @theme.wrap_field(field_type: type_str, html_label: html_label, html_field: html_field.to_s, field_errors: field_errors, wrapper_html_attributes: FormBuilder.safe_string_hash(wrapper_html.is_a?(NamedTuple) ? wrapper_html.to_h : wrapper_html))
    end

    private def input_field(type : String, options : StringHash? = StringHash.new)
      unless INPUT_TYPES.includes?(type.to_s)
        raise ArgumentError.new("Invalid input :type, valid input types are `#{INPUT_TYPES.join(", ")}`")
      end

      options.delete("type")

      boolean_attributes = {"disabled"}

      boolean_options = options.select(boolean_attributes)
      tag_options = options.reject!(boolean_attributes).map{|k, v| "#{k}=\"#{v}\""}
      tag_options = tag_options << boolean_options.keys.join(" ") if !boolean_options.empty?

      "<input type=\"#{type}\"#{" " unless tag_options.empty?}#{tag_options.join(" ")}>"
    end

    private def select_field(collection : (Array(Array) | Array | Range | String), selected : Array(String)? = nil, disabled : Array(String)? = nil, options : StringHash? = StringHash.new)
      FormBuilder.content(element_name: "select", options: options) do
        next(collection) if collection.is_a?(String)

        if collection.first?.is_a?(Array)
          c = collection
        else
          c = collection.map{|x| [x.to_s, x.to_s] }
        end

        String.build do |str|
          c.map do |x|
            str << "<option value=\"#{x[0]}\""
            str << "#{" selected=\"selected\"" if selected && selected.includes?(x[0].to_s)}"
            str << "#{" disabled=\"disabled\"" if disabled && disabled.includes?(x[0].to_s)}"
            str << ">#{x[1]}</option>"
          end
        end
      end
    end

    private def css_safe(value)
      values = value.to_s.strip.split(' ')
      values.map{|v| v.gsub(/[^\w-]+/, " ").strip.gsub(/\s+/, "_")}.join(' ')
    end

  end
end
