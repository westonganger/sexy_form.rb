module FormBuilder
  class Themes
    class Bootstrap2Inline < Themes

      def self.theme_name
        "bootstrap_2_inline"
      end

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          if {"checkbox", "radio"}.includes?(field_type)
            if html_label && (i = html_label.index(">"))
              s << "#{html_label.insert(i+1, "#{html_field} ")}"
            else
              s << html_field
            end
          else
            s << html_field
          end
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String, name : String? = nil, label_text : String? = nil)
        if {"password", "text", "textarea"}.includes?(field_type) && label_text
          html_attrs["placeholder"] = "#{label_text}"
        end

        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String, name : String? = nil, label_text : String? = nil)
        if field_type == "checkbox"
          html_attrs["class"] = "checkbox"
        end

        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs["class"] = "form-inline"
        html_attrs
      end

    end
  end
end
