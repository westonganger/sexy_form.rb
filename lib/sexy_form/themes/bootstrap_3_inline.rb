module SexyForm
  module Themes
    class Bootstrap3Inline < BaseTheme

      def self.theme_name
        "bootstrap_3_inline"
      end

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        s = ""

        wrapper_html_attributes["class"] = "form-group#{" has-error" if html_errors} #{wrapper_html_attributes["class"]}".strip

        attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
        s << "#{attr_str.empty? ? "<div>" : "<div #{attr_str}>"}"

        if ["checkbox", "radio"].include?(field_type)
          if html_label
            s << html_label.sub("\">", "\">#{html_field} ")
          else
            s << "#{html_field}"
          end
        else
          s << "#{html_label}"
          s << "#{html_field}"
        end

        s << "#{html_help_text}"
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
        html_attrs["class"] = "form-inline #{html_attrs["class"]}".strip
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        html_attrs["class"] = "help-block #{html_attrs["class"]}".strip

        s = ""
        s << (html_attrs.empty? ? "<span>" : "<span #{SexyForm.build_html_attr_string(html_attrs)}>")
        s << "#{help_text}"
        s << "</span>"
        s
      end

      def build_html_error(error:, html_attrs:, field_type:)
        html_attrs["class"] = "help-block #{html_attrs["class"]}".strip

        s = ""
        s << (html_attrs.empty? ? "<span>" : "<span #{SexyForm.build_html_attr_string(html_attrs)}>")
        s << "#{error}"
        s << "</span>"
        s
      end

    end
  end
end
