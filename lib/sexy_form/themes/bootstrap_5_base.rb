module SexyForm
  module Themes
    module Bootstrap5Base

      def input_html_attributes(html_attrs:, field_type:, has_errors:)
        html_attrs["class"] ||= ""
        html_attrs["class"].concat(" is-invalid").strip! if has_errors

        case field_type
        when "checkbox", "radio"
          html_attrs["class"].concat(" form-check-input").strip!
        when "select"
          html_attrs["class"].concat(" form-select").strip!
        else
          html_attrs["class"].concat(" form-control").strip!
        end

        html_attrs
      end

      def label_html_attributes(html_attrs:, field_type:, has_errors:)
        if ["checkbox", "radio"].include?(field_type)
          html_attrs["class"] = "form-check-label #{html_attrs['class']}".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        html_attrs["class"] = "form-text #{html_attrs['class']}".strip
        html_attrs["style"] = "display:block; #{html_attrs['style']}".strip

        s = ""
        s << SexyForm.build_html_element(:small, html_attrs)
        s << "#{help_text}"
        s << "</small>"
        s
      end

      def build_html_error(error:, html_attrs:, field_type:)
        html_attrs["class"] = "invalid-feedback #{html_attrs['class']}".strip

        s = ""
        s << SexyForm.build_html_element(:div, html_attrs)
        s << "#{error}"
        s << "</div>"
        s
      end

    end
  end
end
