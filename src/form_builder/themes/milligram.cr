module FormBuilder
  class Themes
    class Milligram < Themes

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          if {"checkbox", "radio"}.includes?(field_type)
            s << html_field
            s << html_label
          else
            s << html_label
            s << html_field
          end
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String)
        if {"checkbox", "radio"}.includes?(field_type)
          html_attrs["class"] = "#{html_attrs["class"]?} label-inline".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs
      end

    end
  end
end
