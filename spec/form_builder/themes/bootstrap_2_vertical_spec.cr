require "../../spec_helper"
require "./theme_spec_helper"

theme_klass = FormBuilder::Themes::Bootstrap2Vertical
theme = theme_klass.new

describe theme_klass do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("bootstrap_2_vertical")
    end
  end

  describe ".wrap_field" do
    it "works" do

    end
  end

  describe "FormBuilder.form" do
    it "matches docs example" do
      expected = String.build do |str|
        str << %(<form method="post">)
          str << %(<div class="control-group">)
            str << %(<label class="control-label" for="inputEmail">Email</label>)
            str << %(<div class="controls">)
              str << %(<input type="text" id="inputEmail" placeholder="Email">)
            str << %(</div>)
          str << %(</div>)
          str << %(<div class="control-group">)
            str << %(<label class="control-label" for="inputPassword">Password</label>)
            str << %(<div class="controls">)
              str << %(<input type="password" id="inputPassword" placeholder="Password">)
            str << %(</div>)
          str << %(</div>)
          str << %(<div class="control-group">)
            str << %(<div class="controls">)
              str << %(<label class="checkbox">)
                str << %(<input type="checkbox"> Remember me)
              str << %(</label>)
            str << %(</div>)
          str << %(</div>)
          str << %(<button type="submit" class="btn">Sign in</button>)
        str << %(</form>)
      end

      actual = FormBuilder.form(theme: theme_klass.theme_name) do |f|
        f << f.field(type: :text, label: "Email", input_html: {id: "inputEmail", placeholder: "Email"})
        f << f.field(type: :password, label: "Password", input_html: {id: "inputPassword", placeholder: "Password"})
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

        theme.input_html_attributes(html_attrs: StringHash.new, field_type: field_type).should eq(attrs)
      end
    end
  end

  describe ".label_html_attributes" do
    FIELD_TYPES.each do |field_type|
      it "returns correct #{field_type} attributes" do
        attrs = StringHash.new

        if {"checkbox", "radio"}.includes?(field_type)
          attrs["class"] = field_type
        else
          attrs["class"] = "control-label"
        end

        attrs["for"] = "foobar"

        theme.label_html_attributes(html_attrs: {"for" => "foobar"}, field_type: field_type).should eq(attrs)
      end
    end
  end

  describe ".form_html_attributes" do
    it "returns correct attributes" do
      attrs = StringHash.new

      theme.form_html_attributes(html_attrs: StringHash.new).should eq(attrs)
    end
  end

end
