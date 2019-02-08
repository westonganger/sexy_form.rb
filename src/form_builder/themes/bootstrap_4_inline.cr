module FormBuilder
  class Themes
    class Bootstrap4Inline < Themes

      def self.theme_name
        "bootstrap_4_inline"
      end

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          if {"checkbox", "radio"}.includes?(field_type)
            form_group_class = " form-check"
          end

          s << %(<div class="form-group#{form_group_class}">)

          if {"checkbox", "radio"}.includes?(field_type)
            s << html_field
            s << html_label
          else
            s << html_label
            s << html_field
          end

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String)
        case field_type
        when "checkbox", "radio"
          html_attrs["class"] = "#{html_attrs["class"]?} form-check-input".strip
        when "file"
          html_attrs["class"] = "#{html_attrs["class"]?} form-control-file".strip
        else
          html_attrs["class"] = "#{html_attrs["class"]?} form-control".strip
        end

        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String)
        if {"checkbox", "radio"}.includes?(field_type)
          html_attrs["class"] = "#{html_attrs["class"]?} form-check-label".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs["class"] = "#{html_attrs["class"]?} form-inline".strip
        html_attrs
      end

    end
  end
end
