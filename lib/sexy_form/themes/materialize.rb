module SexyForm
  class Themes
    class Materialize < Themes

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        String.build do |s|
          wrapper_html_attributes["class"] = "input-field #{wrapper_html_attributes["class"]}".strip

          attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : "<div #{attr_str}>"}"

          if ["checkbox", "radio"].include?(field_type) && html_label
            s << html_label.sub("\">", "\">#{html_field}<span>").sub("</label>", "</span></label>")
          else
            s << html_field
            s << html_label
          end
          s << html_help_text
          s << html_errors.join if html_errors

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs:, field_type:, has_errors:)
        if has_errors?
          html_attrs["class"] = "invalid #{html_attrs["class"]}".strip
        end

        html_attrs
      end

      def label_html_attributes(html_attrs:, field_type:, has_errors:)
        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        html_attrs["class"] = "helper-text #{html_attrs["class"]}".strip

        String.build do |s|
          s << %Q(html_attrs.empty? ? "<span>" : (<span #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << help_text
          s << "</span>"
        end
      end

      def build_html_error(error:, html_attrs:, field_type:)
        html_attrs["class"] = "helper-text #{html_attrs["class"]}".strip

        String.build do |s|
          s << %Q(html_attrs.empty? ? "<span>" : (<span #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << error
          s << "</span>"
        end
      end

    end
  end
end
