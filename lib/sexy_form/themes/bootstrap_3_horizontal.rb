module SexyForm
  class Themes
    class Bootstrap3Horizontal < Themes

      def self.theme_name
        "bootstrap_3_horizontal"
      end

      def initialize(column_classes: ["col-sm-3", "col-sm-9"])
        @column_classes = column_classes.first(2)
        @offset_class = (i = @column_classes[0].index(/-\d/)) ? @column_classes[0].insert(i+1, "offset-") : ""
      end

      def wrap_field(field_type:, html_field:, html_label:, html_help_text: nil, html_errors: nil, wrapper_html_attributes:)
        String.build do |s|
          wrapper_html_attributes["class"] = "form-group#{" has-error" if html_errors} #{wrapper_html_attributes["class"]}".strip

          attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : "<div #{attr_str}>"}"

          if ["checkbox", "radio"].include?(field_type)
            s << %Q(<div class="#{@offset_class} #{@column_classes[1]}">)
            s << %Q(<div class="#{field_type}">)

            if html_label
              s << html_label.sub("\">", "\">#{html_field} ")
            else
              s << html_field
            end
            s << html_help_text
            s << html_errors.join if html_errors

            s << "</div>"
            s << "</div>"
          else
            s << html_label
            s << %Q(<div class="#{"#{@offset_class} " unless html_label}#{@column_classes[1]}">)
            s << html_field
            s << html_help_text
            s << html_errors.join if html_errors
            s << "</div>"
          end

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs:, field_type:, has_errors:)
        html_attrs
      end

      def label_html_attributes(html_attrs:, field_type:, has_errors:)
        unless ["checkbox", "radio"].include?(field_type)
          html_attrs["class"] = " #{@column_classes[0]} control-label #{html_attrs["class"]}".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs:)
        html_attrs["class"] = "form-horizontal #{html_attrs["class"]}".strip
        html_attrs
      end

      def build_html_help_text(help_text:, html_attrs:, field_type:)
        html_attrs["class"] = "help-block #{html_attrs["class"]}".strip

        String.build do |s|
          s << %Q(html_attrs.empty? ? "<span>" : (<span #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << help_text
          s << "</span>"
        end
      end

      def build_html_error(error:, html_attrs:, field_type:)
        html_attrs["class"] = "help-block #{html_attrs["class"]}".strip

        String.build do |s|
          s << %Q(html_attrs.empty? ? "<span>" : (<span #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << error
          s << "</span>"
        end
      end

    end
  end
end
