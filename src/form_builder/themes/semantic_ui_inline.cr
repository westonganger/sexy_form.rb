module FormBuilder
  class Themes
    class SemanticUIInline < Themes

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "inline field #{wrapper_html_attributes["class"]?}".strip

          attr_str = build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if {"checkbox", "radio"}.includes?(field_type)
            s << %(<div class="ui checkbox#{" radio" if field_type == "radio"}">)
            s << html_field
            s << html_label
            s << "</div>"
          else
            s << html_label
            s << html_field
          end

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs["class"] = "ui form #{html_attrs["class"]?}".strip
        html_attrs
      end

    end
  end
end
