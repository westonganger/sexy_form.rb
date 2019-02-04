module FormBuilder
  abstract class Themes

    def self.subclasses
      {{@type.subclasses}}
    end

    def self.from_name(name)
      subclasses.each do |klass|
        if klass.theme_name == name
          return klass
        end
      end

      raise("FormBuilder theme `#{name}` was not found")
    end

    def self.theme_name
      self.name.to_s.split("::").last.underscore
    end

    abstract def wrap_field(field_type : String, label_proc : Proc?, input_proc : Proc, errors : Array(String)?, wrapper_html : OptionHash) : String

    abstract def field_attributes(field_type : String) : Hash(String, String)

    abstract def label_attributes(field_type : String) : Hash(String, String)

  end
end
