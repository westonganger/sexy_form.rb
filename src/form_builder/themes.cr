module FormBuilder
  abstract class Themes

    def self.subclasses
      {{@type.subclasses}}
    end

    abstract def wrap_input(field_type : String, form_type : String, label_proc : Proc?, input_proc : Proc, errors : Array(String)?, wrapper_html: OptionHash) : String

    abstract def field_attributes(field_type : String) : Hash(String, String)

    abstract def label_attributes(field_type : String) : Hash(String, String)

  end
end
