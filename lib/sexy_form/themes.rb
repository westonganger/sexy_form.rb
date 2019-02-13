module SexyForm
  abstract class Themes

    def self.theme_name
      self.name.to_s.split("::").last.underscore
    end

    def self.from_name(name)
      name = name.to_s

      subclasses.each do |klass|
        if klass.theme_name == name
          return klass
        end
      end

      raise ArgumentError.new("SexyForm theme `#{name}` was not found")
    end

    # abstract def wrap_field(
    #   field_type : String,
    #   html_field : String,
    #   html_label : String?,
    #   html_help_text : String?,
    #   html_errors : Array(String)?,
    #   wrapper_html_attributes : StringHash,
    # ) : String

    # abstract def input_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool) : StringHash

    # abstract def label_html_attributes(html_attrs : StringHash, field_type : String, has_errors? : Bool) : StringHash

    # abstract def form_html_attributes(html_attrs : StringHash)  : StringHash

    # abstract def build_html_help_text(help_text : String, html_attrs : StringHash, field_type : String)  : String

    # abstract def build_html_error(error : String, html_attrs : StringHash, field_type : String)  : String

  end
end
