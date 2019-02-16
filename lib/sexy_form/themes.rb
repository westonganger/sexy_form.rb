module SexyForm
  module Themes

    def self.classes
      ObjectSpace.each_object(Class).select{|klass| klass < SexyForm::Themes::BaseTheme }.sort_by{|x| x.name}
    end

    def self.from_name(name)
      name = name.to_s

      classes.each do |klass|
        if klass.theme_name == name
          return klass
        end
      end

      raise ArgumentError.new("SexyForm theme `#{name}` was not found")
    end

  end

end
