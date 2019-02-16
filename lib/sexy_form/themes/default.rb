module SexyForm
  class Themes
    class Default < Themes

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        s = ""

        attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
        s << "#{attr_str.empty? ? "<div>" : "<div #{attr_str}>"}"

        if ["checkbox", "radio"].include?(field_type) && html_label
          s << html_label.sub("\">", "\">#{html_field} ")
        else
          s << html_label.to_s
          s << html_field.to_s
        end
        s << html_help_text.to_s
        s << html_errors.join if html_errors

        s << "</div>"

        s
      end

      def input_html_attributes(html_attrs:, field_type:, has_errors:)
        html_attrs
      end

      def label_html_attributes(html_attrs:, field_type:, has_errors:)
        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        s = ""
        s << (html_attrs.empty? ? "<div>" : "<div #{SexyForm.build_html_attr_string(html_attrs)}>")
        s << "#{help_text}"
        s << "</div>"
        s
      end

      def build_html_error(error:, html_attrs:, field_type:)
        s = ""
        s << (html_attrs.empty? ? "<div>" : "<div #{SexyForm.build_html_attr_string(html_attrs)}>")
        s << "#{error}"
        s << "</div>"
        s
      end

    end
  end
end
