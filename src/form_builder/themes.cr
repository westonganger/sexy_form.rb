module FormBuilder
  abstract class Themes

    def self.subclasses
      {{@type.subclasses}}
    end

    abstract def wrap_input(type : String, label_proc : Proc, input_proc : Proc, errors : Array(String)?) : String

    abstract def input_attributes(type : String) : Hash(String, String)

    abstract def label_attributes(type : String) : Hash(String, String)

  end
end
