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
    it "matches bootstrap 3 docs example with labels" do
      expected = String.build do |str|
        str << %(<form class="form-horizontal" method="post">)
          str << %(<div class="form-group">)
            str << %(<label class="col-sm-3 control-label" for="email">Email</label>)
            str << %(<div class="col-sm-9">)
              str << %(<input type="text" class="form-control" id="email" name="email">)
            str << %(</div>)
          str << %(</div>)

          str << %(<div class="form-group">)
            str << %(<label class="col-sm-3 control-label" for="password">Password</label>)
            str << %(<div class="col-sm-9">)
              str << %(<input type="password" class="form-control" id="password" name="password">)
            str << %(</div>)
          str << %(</div>)

          str << %(<div class="form-group">)
            str << %(<div class="col-sm-offset-3 col-sm-9">)
              str << %(<div class="checkbox">)
                str << %(<label for="remember_me">)
                  str << %(<input type="checkbox" id="remember_me" name="remember_me"> Remember Me)
                str << %(</label>)
              str << %(</div>)
            str << %(</div>)
          str << %(</div>)

          str << %(<button type="submit" class="btn btn-default">Sign in</button>)
        str << %(</form>)
      end

      actual = FormBuilder.form(theme: FormBuilder::Themes::Bootstrap3Horizontal.new(column_classes: ["col-sm-3", "col-sm-9"])) do |f|
        f << f.field(type: :text, name: :email)
        f << f.field(type: :password, name: :password)
        f << f.field(type: :checkbox, name: :remember_me)
        f << %(<button type="submit" class="btn btn-default">Sign in</button>)
      end

      actual.should eq(expected)
    end
  end

  describe ".input_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        unless {"checkbox", "radio"}.includes?(field_type)
          attrs["class"] = "form-control"
        end

        theme.input_html_attributes(html_attrs: StringHash.new, field_type: field_type).should eq(attrs)
      end
    end
  end

  describe ".label_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        unless {"checkbox", "radio"}.includes?(field_type)
          attrs["class"] = "col-sm-3 control-label"
        end

        theme.label_html_attributes(html_attrs: StringHash.new, field_type: field_type).should eq(attrs)
      end
    end
  end

  describe ".form_html_attributes" do
    it "returns correct attributes" do
      attrs = StringHash.new

      attrs["class"] = "form-horizontal"

      theme.form_html_attributes(html_attrs: StringHash.new).should eq(attrs)
    end
  end

end
