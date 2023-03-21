module SexyForm
  class Builder
    INPUT_TYPES = ["checkbox", "file", "hidden", "password", "radio", "text"].freeze
    COLLECTION_KEYS = ["options", "selected", "disabled", "include_blank"].freeze

    def initialize(theme: nil)
      @html = []

      if theme
        if theme.is_a?(SexyForm::Themes::BaseTheme)
          @theme = theme
        else
          @theme = Themes.from_name(theme.to_s).new
        end
      else
        @theme = SexyForm::Themes::Default.new
      end
    end

    def theme
      @theme
    end

    def <<(v)
      v = v.to_s
      @html.push(v)
      v
    end

    ### This method should be considered private
    def html_string
      @html.join("")
    end

    def field(
      type: ,
      name: nil,
      value: nil,
      label: nil,
      help_text: nil,
      errors: nil,
      input_html: {},
      label_html: {},
      help_text_html: {},
      wrapper_html: {},
      error_html: {},
      collection: nil
    )
      type = type.to_s

      if collection && type != "select"
        raise ArgumentError.new("Argument :collection is not supported for type: :#{type}")
      end

      if errors
        SexyForm.verify_argument_type(arg_name: :errors, value: errors, expected_type: [Array, String])
      end

      SexyForm.verify_argument_type(arg_name: :input_html, value: input_html, expected_type: Hash)
      SexyForm.verify_argument_type(arg_name: :label_html, value: label_html, expected_type: Hash)
      SexyForm.verify_argument_type(arg_name: :wrapper_html, value: wrapper_html, expected_type: Hash)
      SexyForm.verify_argument_type(arg_name: :help_text_html, value: help_text_html, expected_type: Hash)
      SexyForm.verify_argument_type(arg_name: :error_html, value: error_html, expected_type: Hash)

      if errors
        if errors.is_a?(String)
          errors = errors.empty? ? nil : [errors]
        else
          errors = errors.reject{|x| x.empty?}

          if errors.empty?
            errors = nil
          end
        end

        if errors.nil?
          html_errors = errors.map{|x|
            @theme.build_html_error(error: x, field_type: type, html_attrs: SexyForm.safe_string_hash(errors))
          }
        end
      end

      themed_input_html = @theme.input_html_attributes(html_attrs: SexyForm.safe_string_hash(input_html), field_type: type, has_errors: (errors && !errors.empty?))

      themed_label_html = @theme.label_html_attributes(html_attrs: SexyForm.safe_string_hash(label_html), field_type: type, has_errors: (errors && !errors.empty?))

      if name
        themed_input_html["name"] ||= name.to_s

        unless themed_input_html.has_key?("id")
          themed_input_html["id"] = css_safe(name)
        end
      end

      if !themed_input_html.has_key?("value") && value && !value.to_s.empty? && INPUT_TYPES.include?(type)
        themed_input_html["value"] = value.to_s
      end

      if themed_input_html.has_key?("id")
        themed_label_html["for"] ||= themed_input_html["id"]
      end

      if ["checkbox", "radio"].include?(type)
        ### Allow passing checked=true/false
        if themed_input_html["checked"] == "true"
          themed_input_html["checked"] = "checked"
        elsif themed_input_html["checked"] == "false"
          themed_input_html.delete("checked")
        end
      end

      case type
      when "checkbox"
        html_field = input_field(type: type, attrs: themed_input_html)
      when "file"
        html_field = input_field(type: type, attrs: themed_input_html)
      when "hidden"
        html_field = input_field(type: type, attrs: themed_input_html)
      when "password"
        html_field = input_field(type: type, attrs: themed_input_html)
      when "radio"
        html_field = input_field(type: type, attrs: themed_input_html)
      when "select"
        if !collection
          raise ArgumentError.new("Required argument `:collection` not provided")
        end

        SexyForm.verify_argument_type(arg_name: :collection, value: collection, expected_type: Hash)

        safe_collection = SexyForm.safe_string_hash(collection)

        if safe_collection.keys.any?{|x| !COLLECTION_KEYS.include?(x) }
          raise ArgumentError.new("Invalid key passed to :collection argument. Supported keys are #{COLLECTION_KEYS.map{|x| ":#{x}"}.join(", ")}")
        end

        if !safe_collection.has_key?("options")
          raise ArgumentError.new("Required argument `collection[:options]` not provided")
        end

        if safe_collection["options"].is_a?(Array)
          collection_options = safe_collection["options"].map do |x|
            if x.is_a?(Enumerable)
              x.first(2).map{|y| y.respond_to?(:to_s) ? y.to_s : ""}
            else
              [(x.respond_to?(:to_s) ? x.to_s : "")]
            end
          end
        elsif safe_collection["options"].is_a?(String)
          collection_options = safe_collection["options"]
        else
          raise ArgumentError.new("Invalid type passed to argument `collection[:options]``")
        end

        if collection_options.is_a?(String)
          ["selected", "disabled", "include_blank"].each do |k|
            if safe_collection.has_key?(k)
              raise ArgumentError.new("Argument `collection[:#{k}]` is not allowed when passing a pre-made HTML Options String to `collection[:options]`")
            end
          end
        else
          if safe_collection.has_key?("include_blank") && safe_collection["include_blank"] != false
            collection_options.unshift([(safe_collection["include_blank"] == true ? "" : "#{safe_collection["include_blank"]}")])
          end

          if safe_collection.has_key?("selected")
            if safe_collection["selected"].is_a?(Array)
              collection_selected = safe_collection["selected"].map{|x| x.respond_to?(:to_s) ? x.to_s : ""}
            else
              collection_selected = [safe_collection["selected"].to_s]
            end
          end

          if safe_collection.has_key?("disabled")
            if safe_collection["disabled"].is_a?(Array)
              collection_disabled = safe_collection["disabled"].map{|x| x.respond_to?(:to_s) ? x.to_s : ""}
            else
              collection_disabled = [safe_collection["disabled"].to_s]
            end
          end
        end

        if value && safe_collection["selected"]
          raise ArgumentError.new("Cannot provide :value and :selected arguments together. The :selected argument is recommended for field `type: :select.`")
        else
          v = safe_collection["selected"] || value
          if v
            safe_collection["selected"] = v
          end
        end

        html_field = select_field(options: collection_options, selected: collection_selected, disabled: collection_disabled, attrs: themed_input_html)
      when "text"
        html_field = input_field(type: type, attrs: themed_input_html)
      when "textarea"
        if themed_input_html.has_key?("size")
          themed_input_html["cols"], themed_input_html["rows"] = themed_input_html.delete("size").to_s.split("x")
        end

        html_field = ""
        html_field << (themed_input_html.empty? ? "<textarea>" : "<textarea #{SexyForm.build_html_attr_string(themed_input_html)}>")
        html_field << "#{themed_input_html["value"]}"
        html_field << "</textarea>"
      end

      if label != false
        if label.is_a?(String)
          label_text = label
        elsif [nil, true].include?(label) && name
          label_text = titleize(name)
        end

        if label_text
          html_label = ""
          html_label << (themed_label_html.empty? ? "<label>" : "<label #{SexyForm.build_html_attr_string(themed_label_html)}>")
          html_label << label_text
          html_label << "</label>"
        end
      end

      if help_text
        html_help_text = @theme.build_html_help_text(field_type: type, help_text: help_text, html_attrs: SexyForm.safe_string_hash(help_text_html))
      end

      @theme.wrap_field(
        field_type: type,
        html_field: html_field,
        html_label: html_label,
        html_help_text: html_help_text,
        html_errors: html_errors,
        wrapper_html_attributes: SexyForm.safe_string_hash(wrapper_html)
      )
    end

    private

    def input_field(type: , attrs: {})
      unless INPUT_TYPES.include?(type.to_s)
        raise ArgumentError.new("Invalid input :type, valid input types are `#{INPUT_TYPES.join(", ")}`")
      end

      attrs.delete("type")

      boolean_attrs = []

      ["disabled"].each do |opt|
        if attrs[opt]
          boolean_attrs.push(attrs[opt])
          attrs.delete(opt)
        end
      end

      str_attrs = attrs.map{|k, v| "#{k}=\"#{v}\""}

      if !boolean_attrs.empty?
        str_attrs.push(boolean_attrs.join(" "))
      end

      "<input type=\"#{type}\"#{" " unless str_attrs.empty?}#{str_attrs.join(" ")}>"
    end

    def select_field(options:, selected: nil, disabled: nil, attrs: {})
      s = ""

      s << (attrs.empty? ? "<select>" : "<select #{SexyForm.build_html_attr_string(attrs)}>")

      if options.is_a?(String)
        s << options
      else
        options.map do |option|
          v = option[0].to_s

          s << "<option value=\"#{v}\""

          if selected
            s << "#{" selected=\"selected\"" if selected.include?(v)}"
          end

          if disabled
            s << "#{" disabled=\"disabled\"" if disabled.include?(v)}"
          end

          s << ">#{option[1] || v}</option>"
        end
      end

      s << "</select>"

      s
    end

    def css_safe(value)
      values = value.to_s.strip.split(" ")
      values.map{|v| v.gsub(/[^\w-]+/, " ").strip.gsub(/\s+/, "_")}.join(" ")
    end

    def titleize(value)
      value.to_s.gsub(/\W|_/, " ").split(" ").map{|x| x.capitalize}.join(" ")
    end

  end
end
