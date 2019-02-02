module FormBuilder
  class Themes
    class Bootstrap3 < Themes

      def wrap_input(type : String, label_proc : Proc, input_proc : Proc, errors : Array(String)?)
        "Foo to the Bar"
      end

      def input_attributes(type : String)
        attrs = {} of String => String
        attrs["class"] = "form-label other-class"
        attrs["style"] = ""
        attrs["data-foo"] = "bar"
        attrs
      end

      def label_attributes(type : String)
        attrs = {} of String => String
        attrs["class"] = "form-label other-class"
        attrs["style"] = ""
        attrs["data-foo"] = "bar"
        attrs
      end

    end
  end
end
