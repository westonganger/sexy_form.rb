module FormBuilder
  class Themes
    class Bootstrap4Vertical < Themes

      def self.theme_name
        "bootstrap_4_vertical"
      end

      def wrap_field(field_type : String, html_field : String, html_label : String?, html_help_text : String?, html_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "form-group #{"form-check" if {"checkbox", "radio"}.includes?(field_type)} #{wrapper_html_attributes["class"]?}".strip

          attr_str = FormBuilder.build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if {"checkbox", "radio"}.includes?(field_type)
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

      def input_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool)
        case field_type
        when "checkbox", "radio"
          html_attrs["class"] = "form-check-input#{" is-invalid" if has_errors?} #{html_attrs["class"]?}".strip
        when "file"
          html_attrs["class"] = "form-control-file#{" is-invalid" if has_errors?} #{html_attrs["class"]?}".strip
        else
          html_attrs["class"] = "form-control#{" is-invalid" if has_errors?} #{html_attrs["class"]?}".strip
        end

        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool)
        if {"checkbox", "radio"}.includes?(field_type)
          html_attrs["class"] = "form-check-label #{html_attrs["class"]?}".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs
      end

      def build_html_help_text(help_text : String, html_attrs : StringHash)
        html_attrs["class"] = "form-text #{html_attrs["class"]?}".strip

        String.build do |s|
          s << html_attrs.empty? ? "<small>" : %(<small #{FormBuilder.build_html_attr_string(html_attrs)}>)
          s << help_text
          s << "</small>"
        end
      end

      def build_html_error(error : String, html_attrs : StringHash)
        html_attrs["class"] = "invalid-feedback #{html_attrs["class"]?}".strip

        s << html_attrs.empty? ? "<div>" : %(<div #{FormBuilder.build_html_attr_string(html_attrs)}>)
        s << error
        s << "</div>"
      end

    end
  end
end
