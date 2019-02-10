module FormBuilder
  class Themes
    class BulmaVertical < Themes

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "field #{wrapper_html_attributes["class"]?}".strip

          attr_str = build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if {"checkbox", "radio"}.includes?(field_type) && html_label && (i = html_label.index(">"))
            s << %(<div class="control">#{html_label.insert(i+1, "#{html_field} ")}</div>)
          else
            s << html_label
            s << %(<div class="control">#{html_field}</div>)
          end

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
          html_attrs["class"] = "label #{html_attrs["class"]?}".strip
        end
        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs
      end

    end
  end
end
