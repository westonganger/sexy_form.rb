module FormBuilder
  class Builder
    FIELD_TYPES = {"checkbox", "file", "hidden", "password", "radio", "select", "text", "textarea"}
    INPUT_TYPES = FIELD_TYPES.to_a - ["select", "textarea"]
    
    @theme : FormBuilder::Themes?
    @html : Array(String) = [] of String

    def initialize(theme : (String | Symbol)? = nil, @errors : Hash(String, Array(String))? = nil)
      if theme
        @theme = Themes.from_name(theme.to_s).new
      end
    end

    def <<(value)
      @html.push(value.to_s)
    end

    def html_string
      @html.join("")
    end

    def field(
      type : (String | Symbol), 
      name : (String | Symbol), 
      value : (String | Symbol)? = nil, 
      label : (Bool | String | Symbol)? = nil, 
      input_html : (NamedTuple | OptionHash) = OptionHash.new, 
      label_html : (NamedTuple | OptionHash) = OptionHash.new, 
      wrapper_html : (NamedTuple | OptionHash) = OptionHash.new, 
      collection : (Array(Array) | Array | Range)? = nil, 
      selected : Array(String)? = nil, 
      disabled : Array(String)? = nil
    )
      unless FIELD_TYPES.includes?(type.to_s)
        raise ArgumentError.new("Invalid :type argument, valid field types are: #{FIELD_TYPES.join(", ")}`")
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

      safe_input_html = FormBuilder.safe_string_hash(input_html.is_a?(NamedTuple) ? input_html.to_h : input_html)
      safe_label_html = FormBuilder.safe_string_hash(label_html.is_a?(NamedTuple) ? label_html.to_h : label_html)
      safe_wrapper_html = FormBuilder.safe_string_hash(wrapper_html.is_a?(NamedTuple) ? wrapper_html.to_h : wrapper_html)

      if ["checkbox", "radio"].includes?(type.to_s)
        ### Allow passing checked=true/false

        if safe_input_html["checked"]? == "true"
          safe_input_html["checked"] = "checked"
        elsif safe_input_html["checked"]? == "false"
          safe_input_html.delete("checked")
        end
      end

      if INPUT_TYPES.includes?(type.to_s)
        safe_input_html["value"] ||= value.to_s
      end

      if label != false
        label_str = "#{label == true ? name.to_s.capitalize : label}"

        if !label_str && !label_str.empty?
          label_proc = -> {
            FormBuilder.content(element_name: "label", options: safe_label_html) do
              label_str
            end
          }
        end
      end

      css_safe_name = css_safe(name)

      unless safe_input_html["id"]?
        safe_input_html["id"] = css_safe_name
      end

      unless safe_input_html["name"]?
        safe_input_html["name"] = css_safe_name
      end

      case type.to_s
      when "checkbox"
        field_html = input_field(type: type.to_s, options: safe_input_html)
      when "file"
        field_html = input_field(type: type.to_s, options: safe_input_html)
      when "hidden"
        field_html = input_field(type: type.to_s, options: safe_input_html)
      when "password"
        field_html = input_field(type: type.to_s, options: safe_input_html)
      when "radio"
        field_html = input_field(type: type.to_s, options: safe_input_html)
      when "select"
        if collection.nil?
          raise ArgumentError.new("Required argument `:collection` not provided while using `type: :select`")
        else
          if value && selected
            raise ArgumentError.new("Cannot provide `:value` and `:selected` arguments together. The `:selected` argument is recommended for field `type: :select.`")
          end

          field_html = select_field(collection: collection, selected: (selected || value), disabled: disabled, options: safe_input_html)
        end
      when "text"
        field_html = input_field(type: type.to_s, options: safe_input_html)
      when "textarea"
        if safe_input_html.has_key?("size")
          safe_input_html["cols"], safe_input_html["rows"] = safe_input_html.delete("size").to_s.split("x")
        end

        field_html = FormBuilder.content(element_name: type.to_s, options: safe_input_html) do
          safe_input_html["value"]? ? safe_input_html["value"].to_s : value.to_s
        end
      end

      field_proc : Proc(String) = -> {
        field_html.to_s
      }

      if (errors = @errors)
        field_errors = errors[name]?
      end

      if (theme = @theme)
        theme.wrap_field(field_type: type.to_s, label_proc: label_proc, field_proc: field_proc, field_errors: field_errors, wrapper_html: safe_wrapper_html)
      else
        "#{label_proc.call if label_proc}#{field_proc.call}"
      end
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

      "<input type=\"#{type}\" #{tag_options.join(" ")}>"
    end

    private def select_field(collection : (Array(Array) | Array | Range), selected : Array(String)? = nil, disabled : Array(String)? = nil, options : StringHash? = StringHash.new)
      if collection.first?.is_a?(Array) 
        c = collection
      else
        c = collection.map{|x| [x.to_s, x.to_s] }
      end

      FormBuilder.content(element_name: "select", options: options) do
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
