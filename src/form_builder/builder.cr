module FormBuilder
  class Builder
    private FIELD_TYPES = {"checkbox", "file", "hidden", "password", "radio", "select", "text", "textarea"}
    private INPUT_TYPES = {"checkbox", "file", "hidden", "password", "radio", "text"}

    @theme : FormBuilder::Themes
    @html : Array(String) = [] of String

    def initialize(theme : (String | Symbol | FormBuilder::Themes)? = nil)
      if theme
        if theme.is_a?(FormBuilder::Themes)
          @theme = theme
        else
          @theme = Themes.from_name(theme.to_s).new
        end
      else
        @theme = FormBuilder::Themes::Default.new
      end
    end

    def <<(value)
      @html.push(value.to_s)
      value.to_s
    end

    def theme
      @theme
    end

    def field(
      type : (String | Symbol),
      name : (String | Symbol)? = nil,
      value : String? = nil,
      label : (Bool | String)? = nil,
      help_text : String? = nil,
      errors : (Array(String) | String)? = nil,
      input_html : (NamedTuple | OptionHash) = OptionHash.new,
      label_html : (NamedTuple | OptionHash) = OptionHash.new,
      help_text_html : (NamedTuple | OptionHash) = OptionHash.new,
      wrapper_html : (NamedTuple | OptionHash) = OptionHash.new,
      collection : (NamedTuple | OptionHash)? = nil,
    )
      type_str = type.to_s

      unless FIELD_TYPES.includes?(type_str)
        raise ArgumentError.new("Invalid :type argument, valid field types are: #{FIELD_TYPES.join(", ")}`")
      end

      if collection && type_str != "select"
        raise ArgumentError.new("Argument :collection is not supported for type: :#{type_str}")
      end

      if errors
        if errors.is_a?(String)
          if !errors.empty?
            safe_errors = [errors]
          end
        else
          errors.reject!{|x| x.empty?}

          if !errors.empty?
            safe_errors = errors
          end
        end
      end

      themed_input_html = @theme.input_html_attributes(html_attrs: FormBuilder.safe_string_hash(input_html.is_a?(NamedTuple) ? input_html.to_h : input_html), field_type: type_str, has_errors?: !safe_errors.nil?)

      themed_label_html = @theme.label_html_attributes(html_attrs: FormBuilder.safe_string_hash(label_html.is_a?(NamedTuple) ? label_html.to_h : label_html), field_type: type_str, has_errors?: !safe_errors.nil?)

      if name
        themed_input_html["name"] ||= name.to_s

        unless themed_input_html.has_key?("id")
          themed_input_html["id"] = css_safe(name)
        end
      end

      if !themed_input_html["value"]? && value && !value.to_s.empty? && INPUT_TYPES.includes?(type_str)
        themed_input_html["value"] = value
      end

      if themed_input_html.has_key?("id")
        themed_label_html["for"] ||= themed_input_html["id"]
      end

      if {"checkbox", "radio"}.includes?(type_str)
        ### Allow passing checked=true/false
        if themed_input_html["checked"]? == "true"
          themed_input_html["checked"] = "checked"
        elsif themed_input_html["checked"]? == "false"
          themed_input_html.delete("checked")
        end
      end

      case type_str
      when "checkbox"
        html_field = input_field(type: type_str, attrs: themed_input_html)
      when "file"
        html_field = input_field(type: type_str, attrs: themed_input_html)
      when "hidden"
        html_field = input_field(type: type_str, attrs: themed_input_html)
      when "password"
        html_field = input_field(type: type_str, attrs: themed_input_html)
      when "radio"
        html_field = input_field(type: type_str, attrs: themed_input_html)
      when "select"
        if !collection
          raise ArgumentError.new("Required argument `:collection` not provided")
        end

        safe_collection = FormBuilder.safe_string_option_hash(collection.is_a?(NamedTuple) ? collection.to_h : collection)

        if !safe_collection.has_key?("options")
          raise ArgumentError.new("Required argument `collection[:options]` not provided")
        end

        if safe_collection["options"].is_a?(Array)
          collection_options = safe_collection["options"].as(Array).map do |x|
            if x.is_a?(Enumerable)
              x.first(2).map{|y| y.responds_to?(:to_s) ? y.to_s : ""}
            else
              [(x.responds_to?(:to_s) ? x.to_s : "")]
            end
          end
        elsif safe_collection["options"].is_a?(String)
          collection_options = safe_collection["options"].as(String)
        else
          raise ArgumentError.new("Invalid argument type passed to `collection[:options]`, must be an Array`")
        end

        if collection_options.is_a?(String)
          {"selected", "disabled", "include_blank"}.each do |k|
            if safe_collection.has_key?(k)
              raise ArgumentError.new("Argument `collection[:#{k}]` is not allowed when passing a pre-made HTML Options String to `collection[:options]`")
            end
          end
        else
          if safe_collection.has_key?("include_blank") && safe_collection["include_blank"] != false
            collection_options.unshift(["#{safe_collection["include_blank"]}"])
          end

          if safe_collection.has_key?("selected")
            if safe_collection["selected"].is_a?(Array)
              collection_selected = safe_collection["selected"].as(Array).map{|x| x.responds_to?(:to_s) ? x.to_s : ""}
            else
              collection_selected = [safe_collection["selected"].to_s]
            end
          end

          if safe_collection.has_key?("disabled")
            if safe_collection["disabled"].is_a?(Array)
              collection_disabled = safe_collection["disabled"].as(Array).map{|x| x.responds_to?(:to_s) ? x.to_s : ""}
            else
              collection_disabled = [safe_collection["disabled"].to_s]
            end
          end
        end

        if value && safe_collection["selected"]?
          raise ArgumentError.new("Cannot provide :value and :selected arguments together. The :selected argument is recommended for field `type: :select.`")
        else
          v = safe_collection["selected"]? || value
          if v
            safe_collection["selected"] = v
          end
        end

        html_field = select_field(options: collection_options, selected: collection_selected, disabled: collection_disabled, attrs: themed_input_html)
      when "text"
        html_field = input_field(type: type_str, attrs: themed_input_html)
      when "textarea"
        if themed_input_html.has_key?("size")
          themed_input_html["cols"], themed_input_html["rows"] = themed_input_html.delete("size").to_s.split("x")
        end

        html_field = String.build do |s|
          s << (themed_input_html.empty? ? "<textarea>" : %(<textarea #{FormBuilder.build_html_attr_string(themed_input_html)}>))
          s << themed_input_html["value"]?
          s << "</textarea>"
        end
      end

      if label != false
        if label.is_a?(String)
          label_text = label
        elsif {nil, true}.includes?(label) && name
          label_text = titleize(name)
        end

        if label_text
          html_label = String.build do |s|
            s << (themed_label_html.empty? ? "<label>" : %(<label #{FormBuilder.build_html_attr_string(themed_label_html)}>))
            s << label_text
            s << "</label>"
          end
        end
      end

      if help_text
        html_help_text = @theme.build_html_help_text(field_type: type_str, help_text: help_text, html_attrs: FormBuilder.safe_string_hash(help_text_html.is_a?(NamedTuple) ? help_text_html.to_h : help_text_html))
      end

      @theme.wrap_field(
        field_type: type_str,
        html_field: html_field.to_s,
        html_label: html_label,
        html_help_text: html_help_text,
        html_errors: safe_errors,
        wrapper_html_attributes: FormBuilder.safe_string_hash(wrapper_html.is_a?(NamedTuple) ? wrapper_html.to_h : wrapper_html)
      )
    end

    private def input_field(type : String, attrs : StringHash? = StringHash.new)
      unless INPUT_TYPES.includes?(type.to_s)
        raise ArgumentError.new("Invalid input :type, valid input types are `#{INPUT_TYPES.join(", ")}`")
      end

      attrs.delete("type")

      boolean_opts = {"disabled"}

      boolean_attrs = attrs.select(boolean_opts)
      tag_attrs = attrs.reject!(boolean_opts).map{|k, v| "#{k}=\"#{v}\""}
      tag_attrs = tag_attrs << boolean_attrs.keys.join(" ") if !boolean_attrs.empty?

      "<input type=\"#{type}\"#{" " unless tag_attrs.empty?}#{tag_attrs.join(" ")}>"
    end

    private def select_field(options : (Array(Array(String)) | String)? = nil, selected : Array(String)? = nil, disabled : Array(String)? = nil, attrs : StringHash? = StringHash.new)
      String.build do |s|
        s << (attrs.empty? ? "<select>" : %(<select #{FormBuilder.build_html_attr_string(attrs)}>))

        if options
          if options.is_a?(String)
            s << options
          else
            options.map do |option|
              v = option[0]?.to_s

              s << "<option value=\"#{v}\""

              if selected
                s << "#{" selected=\"selected\"" if selected.includes?(v)}"
              end

              if disabled
                s << "#{" disabled=\"disabled\"" if disabled.includes?(v)}"
              end

              s << ">#{option[1]? || v}</option>"
            end
          end
        end

        s << "</select>"
      end
    end

    ### This method should be considered private
    def html_string
      @html.join("")
    end

    private def css_safe(value)
      values = value.to_s.strip.split(" ")
      values.map{|v| v.gsub(/[^\w-]+/, " ").strip.gsub(/\s+/, "_")}.join(" ")
    end

    private def titleize(value)
      value.to_s.gsub(/\W|_/, " ").split(" ").join(" "){|x| x.capitalize}
    end

  end
end
