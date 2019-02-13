module SexyForm
  class Themes
    class Milligram < Themes

      def wrap_field(field_type : String, html_field : String, html_label : String?, html_help_text : String?, html_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if ["checkbox", "radio"].include?(field_type)
            s << html_field
            s << html_label
          else
            s << html_label
            s << html_field
          end
          s << html_help_text
          s << html_errors.join if html_errors

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool)
        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool)
        if ["checkbox", "radio"].include?(field_type)
          html_attrs["class"] = "label-inline #{html_attrs["class"]?}".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs
      end

      def build_html_help_text(help_text : String, html_attrs : StringHash, field_type : String)
        String.build do |s|
          s << (html_attrs.empty? ? "<small>" : %(<small #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << help_text
          s << "</small>"
        end
      end

      def build_html_error(error : String, html_attrs : StringHash, field_type : String)
        html_attrs["style"] = "color: red; #{html_attrs["style"]?}".strip

        String.build do |s|
          s << (html_attrs.empty? ? "<small>" : %(<small #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << error
          s << "</small>"
        end
      end

    end
  end
end
