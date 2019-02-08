module FormBuilder
  class Themes
    class Bootstrap2Horizontal < Themes

      def self.theme_name
        "bootstrap_2_horizontal"
      end

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          s << %(<div class="control-group">)

          if {"checkbox", "radio"}.includes?(field_type)
            s << %(<div class="controls">)

            if html_label && (i = html_label.index(">"))
              s << "#{html_label.insert(i+1, "#{html_field} ")}"
            else
              s << html_field
            end

            s << "</div>"
          else
            s << html_label
            s << %(<div class="controls">#{html_field}</div>)
          end

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String, name : String? = nil, label_text : String? = nil)
        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String, name : String? = nil, label_text : String? = nil)
        html_attrs["class"] ||= ""

        if {"checkbox", "radio"}.includes?(field_type)
          html_attrs["class"] = "#{html_attrs["class"]} #{field_type}".strip
        else
          html_attrs["class"] = "#{html_attrs["class"]} control-label".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs["class"] = "form-horizontal"
        html_attrs
      end


    end
  end
end
