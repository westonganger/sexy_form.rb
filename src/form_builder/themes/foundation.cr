module FormBuilder
  class Themes
    class Foundation < Themes

      def wrap_field(field_type : String, html_label : String?, html_field : String, field_errors : Array(String)?, wrapper_html_attributes : StringHash)
        "Foo to the Bar"
      end

      def input_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs["class"] = "form-control"
        html_attrs
      end

      def label_html_attributes(html_attrs : StringHash, field_type : String)
        html_attrs["class"] = "control"
        html_attrs
      end

      def form_html_attributes(html_attrs : StringHash)
        html_attrs["class"] = "form-horizontal"
        html_attrs
      end

    end
  end
end
