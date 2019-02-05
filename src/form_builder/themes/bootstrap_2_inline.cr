module FormBuilder
  class Themes
    class Bootstrap2Inline < Themes

      def self.theme_name
        "bootstrap_2_inline"
      end

      def wrap_field(field_type : String, label_proc : Proc(String)?, field_proc : Proc(String), field_errors : Array(String)?, wrapper_html : OptionHash)
        "Foo to the Bar"
      end

      def field_attributes(field_type : String, name : String? = nil, label_text : String? = nil)
        attrs = {} of String => String
        if label_text
          attrs["placeholder"] = "#{label_text}"
        end
        attrs
      end

      def label_attributes(field_type : String, name : String? = nil, label_text : String? = nil)
        {} of String => String
      end

    end
  end
end
