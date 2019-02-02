module FormBuilder
  class Builder

    def initialize(theme : (String | Symbol)? = nil, @errors : Hash(String, Array(String))? = nil)
      if theme
        @theme = Themes.subclasses.find do |klass|
          name = klass.name.to_s.split("::").last.underscore

          i = name.index(/\d/)

          if i
            name = name.insert(i, "_")
          end

          if name == theme.to_s
            klass
          end
        end || raise("FormBuilder theme '#{theme}' was not found")
      end
    end

    def input(type : (String | Symbol), name : (String | Symbol), value : (String | Symbol)? = nil)
      case type
      when "text", "string"

      when "textarea"

      when "select"

      when "checkbox"

      when "radio"

      when "hidden"

      when "submit"

      end
    end

    # INPUT_BOOLEAN_ATTRIBUTES = [:disabled]

    # def input_field(type : Symbol, **options)
    #   options = options.to_h
    #   input_field_string(type: type, options: options)
    # end

    # def input_field(type : Symbol, options : OptionHash)
    #   input_field_string(type: type, options: options)
    # end

    # def input_field_string(type : Symbol, options : OptionHash)
    #   tag_options = prepare_input_field_options(options: options)
    #   "<input type=\"#{type}\" #{tag_options}/>"
    # end

    # def prepare_input_field_options(options : OptionHash)
    #   options[:id] = options[:name] if (options[:name]?) && !(options[:id]?)
    #   boolean_options = options.select(INPUT_BOOLEAN_ATTRIBUTES)
    #   tag_options = options.reject!(INPUT_BOOLEAN_ATTRIBUTES).map { |k, v| "#{k}=\"#{v}\"" }
    #   tag_options = tag_options << boolean_options.keys.join(" ") if !boolean_options.empty?
    #   tag_options = tag_options.join(" ")
    #   tag_options
    # end

    # def text_field(name : String | Symbol, **options : Object)
    #   options_hash = Kit.safe_hash({:name => name, :id => name}, options)
    #   type = options[:type]? || :text
    #   input_field(type: type, options: options_hash.reject(:type))
    # end

    # def text_field(name : String | Symbol)
    #   text_field(name, id: name)
    # end

    # def file_field(name : String | Symbol, **options : Object)
    #   options_hash = Kit.safe_hash({:name => name, :id => name}, options)
    #   type = options[:type]? || :file
    #   input_field(type: type, options: options_hash.reject(:type))
    # end

    # def file_field(name : String | Symbol)
    #   file_field(name, id: name)
    # end

    # def label(name : String | Symbol, content : String? = nil, **options : Object)
    #   options_hash = Kit.safe_hash({for: name, id: "#{Kit.css_safe(name)}_label"}, options)
    #   FormBuilder.content(element_name: :label, content: (content ? content : name.to_s.capitalize), options: options_hash)
    # end

    # def label(name : String | Symbol, content : String? = nil)
    #   label(name, content: (content ? content : name.to_s.capitalize), for: name, id: "#{Kit.css_safe(name)}_label")
    # end

    # def label(name : String | Symbol)
    #   content = "#{yield}"
    #   label(name, content: content, for: name, id: "#{Kit.css_safe(name)}_label")
    # end

    # def wrapper_field(*args)
    #   return "" unless args.first?
    #   args.join("")
    # end

    # def hidden_field(name : String | Symbol, **options : Object)
    #   options_hash = Kit.safe_hash({:name => name, :id => name}, options)
    #   input_field(type: :hidden, options: options_hash)
    # end

    # def hidden_field(name : String | Symbol)
    #   hidden_field(name: name, id: name)
    # end

    # # with collection Array(Array)
    # def select_field(name : String | Symbol, collection : Array(Array), **options : Object)
    #   options_hash = Kit.safe_hash(options, {:name => name})
    #   selected = [options_hash.delete(:selected)].flatten.map(&.to_s)
    #   FormBuilder.content(element_name: :select, options: options_hash) do
    #     String.build do |str|
    #       collection.map do |item|
    #         str << %(<option value="#{item[0]}"#{selected.includes?(item[0].to_s) ? %( selected="selected") : nil}>#{item[1]}</option>)
    #       end
    #     end
    #   end
    # end

    # # Utilizes method above for when options are not defined and sets class and id.
    # def select_field(name : String | Symbol, collection : Array(Array))
    #   select_field(name, collection, class: name, id: name)
    # end

    # # with collection Array(Hash)
    # def select_field(name : String | Symbol, collection : Array(Hash), **options : Object)
    #   select_field(name, collection.map(&.first.to_a), **options)
    # end

    # def select_field(name : String | Symbol, collection : Array(Hash))
    #   select_field(name, collection.map(&.first.to_a), class: name, id: name)
    # end

    # # with collection Hash
    # def select_field(name : String | Symbol, collection : Hash, **options : Object)
    #   select_field(name, collection.map { |k, v| [k, v] }, **options)
    # end

    # def select_field(name : String | Symbol, collection : Hash)
    #   select_field(name, collection.map { |k, v| [k, v] }, class: name, id: name)
    # end

    # def select_field(name : String | Symbol, collection : NamedTuple, **options : Object)
    #   select_field(name, collection.map { |k, v| [k, v] }, **options)
    # end

    # def select_field(name : String | Symbol, collection : NamedTuple)
    #   select_field(name, collection.map { |k, v| [k, v] }, class: name, id: name)
    # end

    # # with collection Array
    # def select_field(name : String | Symbol, collection : Array | Range, **options : Object)
    #   select_field(name, collection.map { |i| [i.to_s, i.to_s.capitalize] }, **options)
    # end

    # def select_field(name : String | Symbol, collection : Array | Range)
    #   select_field(name, collection.map { |i| [i.to_s, i.to_s.capitalize] }, class: name, id: name)
    # end

    # def text_area(name : String | Symbol, content : String?, **options : Object)
    #   options_hash = Kit.safe_hash({:name => name, :id => name}, options)
    #   options_hash[:cols], options_hash[:rows] = options_hash.delete(:size).to_s.split("x") if options.has_key?(:size)
    #   FormBuilder.content(element_name: :textarea, options: options_hash) do
    #     content
    #   end
    # end

    # def text_area(name : String | Symbol, content : String?)
    #   text_area(name, content, id: name)
    # end

    # def submit(value : String | Symbol = "Save Changes", **options : Object)
    #   options_hash = Kit.safe_hash({value: value}, options)
    #   input_field(type: :submit, options: options_hash)
    # end

    # def submit(value : String | Symbol = "Save Changes")
    #   submit(value: value.to_s, id: value.to_s.gsub(" ", "_").downcase)
    # end

    # def check_box(name : String | Symbol, checked_value = "1", unchecked_value = "0", **options : Object)
    #   options_hash = Kit.safe_hash({:name => name, :id => name, :value => checked_value}, options)
    #   # Allows you to pass in checked=true/false
    #   if options_hash[:checked]?
    #     options_hash[:checked] = "checked"
    #   else
    #     options_hash.delete(:checked)
    #   end

    #   String.build do |str|
    #     str << input_field(type: :checkbox, options: options_hash)
    #     str << hidden_field(name, value: unchecked_value, id: "#{options_hash[:id]}_default")
    #   end
    # end

    # def check_box(name : String | Symbol, checked_value = "1", unchecked_value = "0")
    #   check_box(name, checked_value: checked_value, unchecked_value: unchecked_value, id: name)
    # end

  end
end
