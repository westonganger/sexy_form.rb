module SexyForm
  class Themes
    class BulmaHorizontal < Themes

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        s = ""

        wrapper_html_attributes["class"] = "field is-horizontal #{wrapper_html_attributes["class"]}".strip

        attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
        s << "#{attr_str.empty? ? "<div>" : "<div #{attr_str}>"}"

        unless ["checkbox", "radio"].include?(field_type) && html_label
          s << "#{html_label}"
        end

        s << %Q(<div class="field-body">)
        s << %Q(<div class="field">)
        s << %Q(<div class="control">)

        if ["checkbox", "radio"].include?(field_type) && html_label
          s << html_label.sub("\">", "\">#{html_field} ")
        else
          s << "#{html_field}"
        end

        s << "#{html_help_text}"
        s << html_errors.join if html_errors

        s << "</div>"
        s << "</div>"
        s << "</div>"
        s << "</div>"

        s
      end

      def input_html_attributes(html_attrs:, field_type:, has_errors:)
        if has_errors
          html_attrs["class"] = "is-danger #{html_attrs["class"]}".strip
        end

        html_attrs
      end

      def label_html_attributes(html_attrs:, field_type:, has_errors:)
        if ["checkbox", "radio"].include?(field_type)
          html_attrs["class"] = "#{field_type} #{html_attrs["class"]}".strip
        else
          html_attrs["class"] = "label is-normal #{html_attrs["class"]}".strip
        end
        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        html_attrs["class"] = "help #{html_attrs["class"]}".strip

        s = ""
        s << (html_attrs.empty? ? "<p>" : "<p #{SexyForm.build_html_attr_string(html_attrs)}>")
        s << "#{help_text}"
        s << "</p>"
        s
      end

      def build_html_error(error:, html_attrs:, field_type:)
        html_attrs["class"] = "help is-danger #{html_attrs["class"]}".strip

        s = ""
        s << (html_attrs.empty? ? "<p>" : "<p #{SexyForm.build_html_attr_string(html_attrs)}>")
        s << "#{error}"
        s << "</p>"
        s
      end

    end
  end
end
