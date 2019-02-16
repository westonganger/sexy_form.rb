require_relative "../../spec_helper"
require_relative "./theme_spec_helper"

theme_klass = SexyForm::Themes::Materialize
theme = theme_klass.new

describe theme_klass do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("materialize")
    end
  end

  describe ".wrap_field" do
    it "works" do

    end
  end

  describe "SexyForm.form" do
    it "matches docs example with labels" do
      expected = build_string do |str|
        str << %Q(<form method="post">)
          str << %Q(<div class="input-field">)
            str << %Q(<input type="text" name="email" id="email">)
            str << %Q(<label for="email">Email</label>)
          str << "</div>"

          str << %Q(<div class="input-field">)
            str << %Q(<input type="password" name="password" id="password">)
            str << %Q(<label for="password">Password</label>)
          str << "</div>"

          str << %Q(<div class="input-field">)
            str << %Q(<label for="remember_me">)
              str << %Q(<input type="checkbox" name="remember_me" id="remember_me">)
              str << "<span>Remember Me</span>"
            str << %Q(</label>)
          str << "</div>"

          str << %Q(<button type="submit">Sign in</button>)
        str << "</form>"
      end

      actual = SexyForm.form(theme: theme_klass.theme_name) do |f|
        f << f.field(type: :text, name: :email)
        f << f.field(type: :password, name: :password)
        f << f.field(type: :checkbox, name: :remember_me)
        f << %Q(<button type="submit">Sign in</button>)
      end

      actual.should eq(expected)
    end
  end

  describe ".form_html_attributes" do
    it "returns correct attributes" do
      attrs = {}

      theme.form_html_attributes(html_attrs: {}).should eq(attrs)
    end
  end

  SexyForm::Builder::FIELD_TYPES.each do |field_type|
    describe ".input_html_attributes" do
      it "returns correct #{field_type} attributes" do
        attrs = {}

        theme.input_html_attributes(html_attrs: {}, field_type: field_type, has_errors: false).should eq(attrs)
      end
    end

    describe ".label_html_attributes" do
      it "returns correct #{field_type} attributes" do
        attrs = {}

        theme.label_html_attributes(html_attrs: {}, field_type: field_type, has_errors: false).should eq(attrs)
      end
    end

    describe ".build_html_help_text" do
      it "returns correct #{field_type} attributes" do
        expected = "<span class=\"helper-text\">foobar</span>"

        attrs = {}

        theme.build_html_help_text(html_attrs: attrs, field_type: field_type, help_text: "foobar").should eq(expected)
      end
    end

    describe ".build_html_error" do
      it "returns correct #{field_type} attributes" do
        expected = "<span class=\"helper-text\">foobar</span>"

        attrs = {}

        theme.build_html_error(html_attrs: attrs, field_type: field_type, error: "foobar").should eq(expected)
      end
    end
  end

end
