module SexyForm
  class Themes
    class Bootstrap2Inline < Themes

      def self.theme_name
        "bootstrap_2_inline"
      end

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        s = ""

        if html_errors
          wrapper_html_attributes["class"] = "error #{wrapper_html_attributes["class"]}".strip
        end

        attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
        s << "#{attr_str.empty? ? "<div>" : "<div #{attr_str}>"}"

        if ["checkbox", "radio"].include?(field_type) && html_label
          s << html_label.sub("\">", "\">#{html_field} ")
        else
          s << html_label
          s << html_field
        end
        s << html_help_text
        s << html_errors.join if html_errors

        s << "</div>"

        s
      end

      def input_html_attributes(html_attrs:, field_type:, has_errors:)
        html_attrs
      end

      def label_html_attributes(html_attrs:, field_type:, has_errors:)
        if ["checkbox", "radio"].include?(field_type)
          html_attrs["class"] = "#{field_type} #{html_attrs["class"]}".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs["class"] = "form-inline #{html_attrs["class"]}".strip
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        html_attrs["class"] = "help-block #{html_attrs["class"]}".strip

        s = ""
        s << (html_attrs.empty? ? "<span>" : "<span #{SexyForm.build_html_attr_string(html_attrs)}>")
        s << help_text
        s << "</span>"
        s
      end

      def build_html_error(error:, html_attrs:, field_type:)
        html_attrs["class"] = "help-block #{html_attrs["class"]}".strip

        s = ""
        s << (html_attrs.empty? ? "<span>" : "<span #{SexyForm.build_html_attr_string(html_attrs)}>")
        s << error
        s << "</span>"
        s
      end

    end
  end
end
