module SexyForm
  module Themes
    class Bootstrap5Vertical < BaseTheme
      include Bootstrap5Base

      def self.theme_name
        "bootstrap_5_vertical"
      end

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        s = ""

        if ["checkbox", "radio"].include?(field_type)
          wrapper_html_attributes["class"] = "form-check #{wrapper_html_attributes['class']}".strip
        end

        s << SexyForm.build_html_element(:div, wrapper_html_attributes)

        if ["checkbox", "radio"].include?(field_type)
          s << "#{html_field}"
          s << "#{html_label}"
        else
          s << "#{html_label}"
          s << "#{html_field}"
        end
        s << "#{html_help_text}"
        s << html_errors.join if html_errors

        s << "</div>"

        s
      end

    end
  end
end
