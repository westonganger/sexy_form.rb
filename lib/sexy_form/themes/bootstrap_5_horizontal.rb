module SexyForm
  module Themes
    class Bootstrap5Horizontal < BaseTheme
      include Bootstrap5Base

      def self.theme_name
        "bootstrap_5_horizontal"
      end

      def initialize(column_classes: ["col-sm-3", "col-sm-9"])
        @column_classes = column_classes.first(2)

        s = "#{@column_classes[0]}"
        @offset_class = (i = s.index(/-\d/)) ? s.insert(i+1, "offset-") : ""
      end

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        s = ""

        s << SexyForm.build_html_element(:div, wrapper_html_attributes)

        if ["checkbox", "radio"].include?(field_type)
          s << %Q(<div class="row">)

          s << %Q(<div class="#{@column_classes[0]}"></div>)

          s << %Q(<div class="#{@column_classes[1]}">)
          s << %Q(<div class="form-check">)
          s << "#{html_field}"
          s << "#{html_label}"
          s << "#{html_help_text}"
          s << html_errors.join if html_errors
          s << "</div>"
          s << "</div>"

          s << "</div>"
        else
          s << %Q(<div class="row">)

          s << %Q(<div class="#{@column_classes[0]}">)
          s << "#{html_label}"
          s << "</div>"

          s << %Q(<div class="#{@column_classes[1]}">)
          s << "#{html_field}"
          s << "#{html_help_text}"
          s << html_errors.join if html_errors
          s << "</div>"

          s << "</div>"
        end

        s << "</div>"
      end
    end
  end
end
