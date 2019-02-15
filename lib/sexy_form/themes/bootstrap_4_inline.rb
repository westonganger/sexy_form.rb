module SexyForm
  class Themes
    class Bootstrap4Inline < Themes

      def self.theme_name
        "bootstrap_4_inline"
      end

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        String.build do |s|
          wrapper_html_attributes["class"] = "form-group #{"form-check" if ["checkbox", "radio"].include?(field_type)} #{wrapper_html_attributes["class"]}".strip

          attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : "<div #{attr_str}>"}"

          if ["checkbox", "radio"].include?(field_type)
            s << html_field
            s << html_label
          else
            s << html_label
            s << html_field
          end
          s << html_help_text
          s << html_errors.join if html_errors

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs:, field_type:, has_errors:)
        case field_type
        when "checkbox", "radio"
          html_attrs["class"] = "form-check-input#{" is-invalid" if has_errors} #{html_attrs["class"]}".strip
        when "file"
          html_attrs["class"] = "form-control-file#{" is-invalid" if has_errors} #{html_attrs["class"]}".strip
        else
          html_attrs["class"] = "form-control#{" is-invalid" if has_errors} #{html_attrs["class"]}".strip
        end

        html_attrs
      end

      def label_html_attributes(html_attrs:, field_type:, has_errors:)
        if ["checkbox", "radio"].include?(field_type)
          html_attrs["class"] = "form-check-label #{html_attrs["class"]}".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs["class"] = "form-inline #{html_attrs["class"]}".strip
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        html_attrs["class"] = "form-text #{html_attrs["class"]}".strip

        String.build do |s|
          s << %Q(html_attrs.empty? ? "<small>" : (<small #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << help_text
          s << "</small>"
        end
      end

      def build_html_error(error:, html_attrs:, field_type:)
        html_attrs["class"] = "invalid-feedback #{html_attrs["class"]}".strip

        String.build do |s|
          s << %Q(html_attrs.empty? ? "<div>" : (<div #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << error
          s << "</div>"
        end
      end

    end
  end
end
