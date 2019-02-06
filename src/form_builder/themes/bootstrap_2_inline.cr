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
              s << "#{html_label.insert(i, html_field)}"
            else
              s << html_field
            end
          else
            s << html_label
            s << html_field
          end
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String, name : String? = nil, label_text : String? = nil)
        attrs = StringHash.new

        if {"password", "text", "textarea"}.includes?(field_type) && label_text
          attrs["placeholder"] = "#{label_text}"
        end

        attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String, name : String? = nil, label_text : String? = nil)
        attrs = StringHash.new

        if field_type == "checkbox"
          attrs["class"] = "checkbox"
        end

        attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs["class"] = "form-horizontal"
        html_attrs
      end

    end
  end
end
