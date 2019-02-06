module FormBuilder
  class Themes
    class Bootstrap2Horizontal < Themes

      def self.theme_name
        "bootstrap_2_horizontal"
      end

      def wrap_field(field_type : String, label_proc : Proc(String)?, field_proc : Proc(String), field_errors : Array(String)?, wrapper_html : OptionHash)
        "Foo to the Bar"
      end

      def field_attributes(field_type : String, name : String? = nil, label_text : String? = nil)
        attrs = StringHash.new
        attrs["class"] = "form-label other-class"
        attrs["style"] = ""
        attrs["data-foo"] = "bar"
        attrs
      end

      def label_attributes(field_type : String, name : String? = nil, label_text : String? = nil)
        attrs = StringHash.new
        attrs["class"] = "form-label other-class"
        attrs["style"] = ""
        attrs["data-foo"] = "bar"
        attrs
      end

    end
  end
end
