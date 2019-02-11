require "../../spec_helper"
require "./theme_spec_helper"

theme_klass = FormBuilder::Themes::Bootstrap4Inline
theme = theme_klass.new

describe theme_klass do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("bootstrap_4_inline")
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
            str << %(<input type="text" class="form-control" name="email" id="email">)
          str << "</div>"

          str << %(<div class="form-group">)
            str << %(<label for="password">Password</label>)
            str << %(<input type="password" class="form-control" name="password" id="password">)
          str << "</div>"

          str << %(<div class="form-group form-check">)
            str << %(<input type="checkbox" class="form-check-input" name="remember_me" id="remember_me">)
            str << %(<label class="form-check-label" for="remember_me">Remember Me</label>)
          str << "</div>"

          str << %(<button type="submit" class="btn btn-primary">Sign in</button>)
        str <<%(</form>)
      end

      actual = FormBuilder.form(theme: theme_klass.theme_name) do |f|
        f << f.field(type: :text, name: :email)
        f << f.field(type: :password, name: :password)
        f << f.field(type: :checkbox, name: :remember_me)
        f << %(<button type="submit" class="btn btn-primary">Sign in</button>)
      end

      actual.should eq(expected)
    end
  end

  describe ".input_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        case field_type
        when "checkbox", "radio"
          attrs["class"] = "form-check-input"
        when "file"
          attrs["class"] = "form-control-file"
        else
          attrs["class"] = "form-control"
        end

        theme.input_html_attributes(html_attrs: StringHash.new, field_type: field_type, has_errors?: false).should eq(attrs)
      end
    end
  end

  describe ".label_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        if {"checkbox", "radio"}.includes?(field_type)
          attrs["class"] = "form-check-label"
        end

        theme.label_html_attributes(html_attrs: StringHash.new, field_type: field_type, has_errors?: false).should eq(attrs)
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
