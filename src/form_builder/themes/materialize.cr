module FormBuilder
  class Themes
    class Materialize < Themes

      def wrap_field(field_type : String, html_field : String, html_label : String?, html_help_text : String?, html_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "input-field #{wrapper_html_attributes["class"]?}".strip

          attr_str = build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if {"checkbox", "radio"}.includes?(field_type) && html_label
            s << html_label.sub("\">", "\">#{html_field}<span>").sub("</label>", "</span></label>")
          else
            s << html_field
            s << html_label
          end
          s << html_help_text
          s << html_errors.join if html_errors

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool)
        if has_errors?
          html_attrs["class"] = "invalid #{html_attrs["class"]?}".strip
        end

        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool)
        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs
      end

      def build_html_help_text(help_text : String, html_attrs : StringHash)
        html_attrs["class"] = "helper-text #{html_attrs["class"]?}".strip

        String.build do |s|
          s << html_attrs.empty? ? "<span>" : %(<span #{build_html_attr_string(html_attrs)}>)
          s << help_text
          s << "</span>"
        end
      end

      def build_html_error(error : String, html_attrs : StringHash)
        html_attrs["class"] = "helper-text #{html_attrs["class"]?}".strip

        s << html_attrs.empty? ? "<span>" : %(<span #{build_html_attr_string(html_attrs)}>)
        s << error
        s << "</span>"
      end

    end
  end
end
