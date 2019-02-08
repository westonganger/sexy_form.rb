require "../../spec_helper"
require "./theme_spec_helper"

theme_klass = FormBuilder::Themes::Bootstrap2Inline
theme = theme_klass.new

describe theme_klass do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("bootstrap_2_inline")
    end
  end

  describe ".wrap_field" do
    it "works" do

    end
  end

  describe "FormBuilder.form" do
    it "matches bootstrap 2 docs example" do
      expected = String.build do |str|
        str << %(<form class="form-inline" method="post">)
          str << %(<input type="text" class="input-small" placeholder="Email">)
          str << %(<input type="password" class="input-small" placeholder="Password">)
          str << %(<label class="checkbox">)
            str << %(<input type="checkbox"> Remember me)
          str << %(</label>)
          str << %(<button type="submit" class="btn">Sign in</button>)
        str <<%(</form>)
      end

      actual = FormBuilder.form(theme: :bootstrap_2_inline) do |f|
        f << f.field(type: :text, label: "Email", input_html: {class: "input-small"})
        f << f.field(type: :password, label: "Password", input_html: {class: "input-small"})
        f << f.field(type: :checkbox, label: "Remember me")
        f << %(<button type="submit" class="btn">Sign in</button>)
      end

      actual.should eq(expected)
    end
  end

  describe ".input_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        if {"password", "text", "textarea"}.includes?(field_type)
          attrs["placeholder"] = "Foobar"
        end

        theme.input_html_attributes(html_attrs: StringHash.new, field_type: field_type, label_text: "Foobar").should eq(attrs)
      end
    end
  end

  describe ".label_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        if {"checkbox", "radio"}.includes?(field_type)
          attrs["class"] = field_type
        end

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
