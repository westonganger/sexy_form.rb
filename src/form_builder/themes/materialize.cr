module FormBuilder
  class Themes
    class Materialize < Themes

      def wrap_field(field_type : String, label_proc : Proc(String)?, field_proc : Proc(String), field_errors : Array(String)?, wrapper_html : OptionHash)
        "Foo to the Bar"
      end

      def field_attributes(field_type : String)
        attrs = {} of String => String
        attrs["class"] = "form-label other-class"
        attrs["style"] = ""
        attrs["data-foo"] = "bar"
        attrs
      end

      def label_attributes(field_type : String)
        attrs = {} of String => String
        attrs["class"] = "form-label other-class"
        attrs["style"] = ""
        attrs["data-foo"] = "bar"
        attrs
      end

    end
  end
end
