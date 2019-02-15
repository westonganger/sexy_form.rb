module SexyForm
  class Themes
    class SemanticUIInline < Themes

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        String.build do |s|
          wrapper_html_attributes["class"] = "inline field#{" error" if html_errors} #{wrapper_html_attributes["class"]}".strip

          attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : "<div #{attr_str}>"}"

          if ["checkbox", "radio"].include?(field_type)
            s << %Q(<div class="ui checkbox#{" radio" if field_type == "radio"}">)
            s << html_field
            s << html_label
            s << "</div>"
          else
            s << html_label
            s << html_field
          end
          s << html_help_text
          s << html_errors.join if html_errors

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs:, field_type:, has_errors:)
        html_attrs
      end

      def label_html_attributes(html_attrs:, field_type:, has_errors:)
        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs["class"] = "ui form #{html_attrs["class"]}".strip
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        String.build do |s|
          s << %Q(html_attrs.empty? ? "<div>" : (<div #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << help_text
          s << "</div>"
        end
      end

      def build_html_error(error:, html_attrs:, field_type:)
        html_attrs["style"] = "color: red; #{html_attrs["style"]}".strip

        String.build do |s|
          s << %Q(html_attrs.empty? ? "<div>" : (<div #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << error
          s << "</div>"
        end
      end

    end
  end
end
