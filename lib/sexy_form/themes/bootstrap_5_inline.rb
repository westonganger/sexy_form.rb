module SexyForm
  module Themes
    class Bootstrap5Inline < BaseTheme
      include Bootstrap5Base

      def self.theme_name
        "bootstrap_5_inline"
      end

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        s = ""

        if ["checkbox", "radio"].include?(field_type)
          wrapper_html_attributes["class"] = "col-auto form-check #{wrapper_html_attributes['class']}".strip

          s << SexyForm.build_html_element(:div, wrapper_html_attributes)
          s << html_field
          s << html_label
        else
          s << %Q(<div class="col-auto">#{html_label}</div>)
          s << %Q(<div class="col-auto">)
          s << html_field
        end

        s << "#{html_help_text}"
        s << html_errors.join if html_errors
        s << "</div>"

        s
      end

      def form_html_attributes(html_attrs:)
        html_attrs["class"] = "row #{html_attrs['class']}".strip
        super(html_attrs: html_attrs)
      end

    end
  end
end
