module FormBuilder
  class Themes
    class BulmaHorizontal < Themes

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "field is-horizontal #{wrapper_html_attributes["class"]?}".strip

          attr_str = build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          unless {"checkbox", "radio"}.includes?(field_type) && html_label
            s << html_label
          end

          s << %(<div class="field-body">)
          s << %(<div class="field">)
          s << %(<div class="control">)

          if {"checkbox", "radio"}.includes?(field_type) && html_label
            s << html_label.sub("\">", "\">#{html_field} ")
          else
            s << html_field
          end

          s << "</div>"
          s << "</div>"
          s << "</div>"
          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String)
        if {"checkbox", "radio"}.includes?(field_type)
          html_attrs["class"] = "#{field_type} #{html_attrs["class"]?}".strip
        else
          html_attrs["class"] = "label is-normal #{html_attrs["class"]?}".strip
        end
        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs
      end

    end
  end
end
