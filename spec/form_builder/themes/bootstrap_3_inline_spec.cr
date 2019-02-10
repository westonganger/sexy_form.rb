require "../../spec_helper"
require "./theme_spec_helper"

theme_klass = FormBuilder::Themes::Bootstrap3Inline
theme = theme_klass.new

describe theme_klass do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("bootstrap_3_inline")
    end
  end

  describe ".wrap_field" do
    it "works" do

    end
  end

  describe "FormBuilder.form" do
    it "matches docs example" do
      expected = String.build do |str|
        str << %(<form class="form-inline" method="post">)
          str << %(<div class="form-group">)
            str << %(<label for="email">Email</label>)
            str << %(<input type="text" name="email" id="email">)
          str << "</div>"

          str << %(<div class="form-group">)
            str << %(<label for="password">Password</label>)
            str << %(<input type="password" name="password" id="password">)
          str << "</div>"

          str << %(<div class="form-group">)
            str << %(<label for="remember_me">)
              str << %(<input type="checkbox" name="remember_me" id="remember_me"> Remember Me)
            str << %(</label>)
          str << "</div>"

          str << %(<button type="submit" class="btn">Sign in</button>)
        str <<%(</form>)
      end

      actual = FormBuilder.form(theme: theme_klass.theme_name) do |f|
        f << f.field(type: :text, name: :email)
        f << f.field(type: :password, name: :password)
        f << f.field(type: :checkbox, name: :remember_me)
        f << %(<button type="submit" class="btn">Sign in</button>)
      end

      actual.should eq(expected)
    end
  end

  describe ".input_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        theme.input_html_attributes(html_attrs: StringHash.new, field_type: field_type).should eq(attrs)
      end
    end
  end

  describe ".label_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        theme.label_html_attributes(html_attrs: StringHash.new, field_type: field_type).should eq(attrs)
      end
    end
  end

  describe ".form_html_attributes" do
    it "returns correct attributes" do
      attrs = StringHash.new

      attrs["class"] = "form-inline"

      theme.form_html_attributes(html_attrs: StringHash.new).should eq(attrs)
    end
  end

end
