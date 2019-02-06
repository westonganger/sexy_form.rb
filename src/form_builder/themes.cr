module FormBuilder
  abstract class Themes

    def self.theme_name
      self.name.to_s.split("::").last.underscore
    end

    def self.subclasses
      {{@type.subclasses}}
    end

    def self.from_name(name : String)
      subclasses.each do |klass|
        if klass.theme_name == name
          return klass
        end
      end

      raise ArgumentError.new("FormBuilder theme `#{name}` was not found")
    end

    abstract def wrap_field(
      field_type : String,
      html_label : String?,
      html_field : String,
      field_errors : Array(String)?,
      wrapper_html_attributes : StringHash
    ) : String

    abstract def input_html_attributes(html_attrs : StringHash, field_type : String, name : String? = nil, label_text : String? = nil) : StringHash

    abstract def label_html_attributes(html_attrs : StringHash, field_type : String, name : String? = nil, label_text : String? = nil) : StringHash

    abstract def form_html_attributes(html_attrs : StringHash)  : StringHash

  end
end
