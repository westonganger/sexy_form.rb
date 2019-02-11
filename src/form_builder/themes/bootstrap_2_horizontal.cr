module FormBuilder
  class Themes
    class Bootstrap2Horizontal < Themes

      def self.theme_name
        "bootstrap_2_horizontal"
      end

      def wrap_field(field_type : String, html_field : String, html_label : String?, html_help_text : String?, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "control-group #{wrapper_html_attributes["class"]?}".strip

          attr_str = build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if {"checkbox", "radio"}.includes?(field_type)
            s << %(<div class="controls">)

            if html_label
              s << html_label.sub("\">", "\">#{html_field} ")
            else
              s << html_field
            end
            s << html_help_text

            s << "</div>"
          else
            s << html_label
            s << %(<div class="controls">#{html_field}#{html_help_text}</div>)
          end

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs["class"] ||= ""

        if {"checkbox", "radio"}.includes?(field_type)
          html_attrs["class"] = "#{field_type} #{html_attrs["class"]}".strip
        else
          html_attrs["class"] = "control-label #{html_attrs["class"]}".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs["class"] = "form-horizontal #{html_attrs["class"]?}".strip
        html_attrs
      end

      def build_html_help_text(help_text : String, html_attrs : StringHash)
        html_attrs["class"] = "help-inline #{html_attrs["class"]?}".strip

        String.build do |s|
          s << html_attrs.empty? ? %(<span #{build_html_attr_string(html_attrs)}>) : "<span>"
          s << "#{help_text}</span>"
        end
      end

    end
  end
end
