module SexyForm
  class Themes
    class BulmaVertical < Themes

      def wrap_field(field_type : String, html_field : String, html_label : String?, html_help_text : String?, html_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "field #{wrapper_html_attributes["class"]?}".strip

          attr_str = SexyForm.build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if ["checkbox", "radio"].include?(field_type) && html_label
            s << %(<div class="control">)
            s << html_label.sub("\">", "\">#{html_field} ")
          else
            s << html_label
            s << %(<div class="control">)
            s << html_field
          end
          s << html_help_text
          s << html_errors.join if html_errors
          s << "</div>"

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool)
        if has_errors?
          html_attrs["class"] = "is-danger #{html_attrs["class"]?}".strip
        end

        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool)
        if ["checkbox", "radio"].include?(field_type)
          html_attrs["class"] = "#{field_type} #{html_attrs["class"]?}".strip
        else
          html_attrs["class"] = "label #{html_attrs["class"]?}".strip
        end
        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs
      end

      def build_html_help_text(help_text : String, html_attrs : StringHash, field_type : String)
        html_attrs["class"] = "help #{html_attrs["class"]?}".strip

        String.build do |s|
          s << (html_attrs.empty? ? "<p>" : %(<p #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << help_text
          s << "</p>"
        end
      end

      def build_html_error(error : String, html_attrs : StringHash, field_type : String)
        html_attrs["class"] = "help is-danger #{html_attrs["class"]?}".strip

        String.build do |s|
          s << (html_attrs.empty? ? "<p>" : %(<p #{SexyForm.build_html_attr_string(html_attrs)}>))
          s << error
          s << "</p>"
        end
      end

    end
  end
end
