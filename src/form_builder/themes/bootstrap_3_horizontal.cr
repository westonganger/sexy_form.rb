module FormBuilder
  class Themes
    class Bootstrap3Horizontal < Themes

      def self.theme_name
        "bootstrap_3_horizontal"
      end

      def initialize(@column_classes : Array(String) = ["col-sm-3", "col-sm-9"])
        @column_classes = @column_classes.first(2)
        @offset_class = (i = @column_classes[0].index(/-\d/)) ? @column_classes[0].insert(i+1, "offset-") : ""
      end

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        String.build do |s|
          wrapper_html_attributes["class"] = "form-group #{wrapper_html_attributes["class"]?}".strip

          attr_str = build_html_attr_string(wrapper_html_attributes)
          s << "#{attr_str.empty? ? "<div>" : %(<div #{attr_str}>)}"

          if {"checkbox", "radio"}.includes?(field_type)
            s << %(<div class="#{@offset_class} #{@column_classes[1]}">)
            s << %(<div class="#{field_type}">)

            if html_label && (i = html_label.index("\">"))
              s << "#{html_label.insert(i+2, "#{html_field} ")}"
            else
              s << html_field
            end

            s << "</div>"
            s << "</div>"
          else
            s << html_label
            s << %(<div class="#{"#{@offset_class} " unless html_label}#{@column_classes[1]}">#{html_field}</div>)
          end

          s << "</div>"
        end
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String)
        unless {"checkbox", "radio"}.includes?(field_type)
          html_attrs["class"] = " #{@column_classes[0]} control-label #{html_attrs["class"]?}".strip
        end

        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs["class"] = "form-horizontal #{html_attrs["class"]?}".strip
        html_attrs
      end


    end
  end
end
