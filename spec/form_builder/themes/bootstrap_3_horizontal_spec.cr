require "../../spec_helper"
require "./theme_spec_helper"

theme_klass = FormBuilder::Themes::Bootstrap3Horizontal
theme = theme_klass.new

describe theme_klass do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("bootstrap_3_horizontal")
    end
  end

  describe ".wrap_field" do
    it "works" do

    end
  end

  describe "FormBuilder.form" do
    it "matches docs example" do
      expected = String.build do |str|
        str << %(<form class="form-horizontal" method="post">)
          str << %(<div class="form-group">)
            str << %(<label class="col-sm-3 control-label" for="email">Email</label>)
            str << %(<div class="col-sm-9">)
              str << %(<input type="text" name="email" id="email">)
            str << %(</div>)
          str << %(</div>)

          str << %(<div class="form-group">)
            str << %(<label class="col-sm-3 control-label" for="password">Password</label>)
            str << %(<div class="col-sm-9">)
              str << %(<input type="password" name="password" id="password">)
            str << %(</div>)
          str << %(</div>)

          str << %(<div class="form-group">)
            str << %(<div class="col-sm-offset-3 col-sm-9">)
              str << %(<div class="checkbox">)
                str << %(<label for="remember_me">)
                  str << %(<input type="checkbox" name="remember_me" id="remember_me"> Remember Me)
                str << %(</label>)
              str << %(</div>)
            str << %(</div>)
          str << %(</div>)

          str << %(<button type="submit" class="btn btn-default">Sign in</button>)
        str << %(</form>)
      end

      actual = FormBuilder.form(theme: theme_klass.new(column_classes: ["col-sm-3", "col-sm-9"])) do |f|
        f << f.field(type: :text, name: :email)
        f << f.field(type: :password, name: :password)
        f << f.field(type: :checkbox, name: :remember_me)
        f << %(<button type="submit" class="btn btn-default">Sign in</button>)
      end

      actual.should eq(expected)
    end
  end

  describe ".form_html_attributes" do
    it "returns correct attributes" do
      attrs = StringHash.new

      attrs["class"] = "form-horizontal"

      theme.form_html_attributes(html_attrs: StringHash.new).should eq(attrs)
    end
  end

  FIELD_TYPES.each do |field_type|
    describe ".input_html_attributes" do
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        theme.input_html_attributes(html_attrs: StringHash.new, field_type: field_type, has_errors?: false).should eq(attrs)
      end
    end

    describe ".label_html_attributes" do
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        unless {"checkbox", "radio"}.includes?(field_type)
          attrs["class"] = "col-sm-3 control-label"
        end

        theme.label_html_attributes(html_attrs: StringHash.new, field_type: field_type, has_errors?: false).should eq(attrs)
      end
    end

    describe ".build_html_help_text" do
      it "returns correct #{field_type} attributes" do
        expected = "<span class=\"help-block\">foobar</span>"

        attrs = StringHash.new

        theme.build_html_help_text(html_attrs: attrs, field_type: field_type, help_text: "foobar").should eq(expected)
      end
    end

    describe ".build_html_error" do
      it "returns correct #{field_type} attributes" do
        expected = "<span class=\"help-block\">foobar</span>"

        attrs = StringHash.new

        theme.build_html_error(html_attrs: attrs, field_type: field_type, error: "foobar").should eq(expected)
      end
    end
  end

end
