require_relative "../../spec_helper"
require_relative "./theme_spec_helper"

theme_klass = SexyForm::Themes::BulmaHorizontal
theme = theme_klass.new

describe theme_klass do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("bulma_horizontal")
    end
  end

  describe ".wrap_field" do
    it "works" do

    end
  end

  describe "SexyForm.form" do
    it "matches docs example with labels" do
      expected = String.build do |str|
        str << %Q(<form method="post">)
          str << %Q(<div class="field is-horizontal">)
            str << %Q(<label class="label is-normal" for="email">Email</label>)
            str << %Q(<div class="field-body">)
              str << %Q(<div class="field">)
                str << %Q(<div class="control">)
                  str << %Q(<input type="text" name="email" id="email">)
                str << "</div>"
              str << "</div>"
            str << "</div>"
          str << "</div>"

          str << %Q(<div class="field is-horizontal">)
            str << %Q(<label class="label is-normal" for="password">Password</label>)
            str << %Q(<div class="field-body">)
              str << %Q(<div class="field">)
                str << %Q(<div class="control">)
                  str << %Q(<input type="password" name="password" id="password">)
                str << "</div>"
              str << "</div>"
            str << "</div>"
          str << "</div>"

          str << %Q(<div class="field is-horizontal">)
            str << %Q(<div class="field-body">)
              str << %Q(<div class="field">)
                str << %Q(<div class="control">)
                  str << %Q(<label class="checkbox" for="remember_me">)
                    str << %Q(<input type="checkbox" name="remember_me" id="remember_me"> Remember Me)
                  str << %Q(</label>)
                str << "</div>"
              str << "</div>"
            str << "</div>"
          str << "</div>"

          str << %Q(<button type="submit" class="button">Sign in</button>)
        str << "</form>"
      end

      actual = SexyForm.form(theme: theme_klass.theme_name) do |f|
        f << f.field(type: :text, name: :email)
        f << f.field(type: :password, name: :password)
        f << f.field(type: :checkbox, name: :remember_me)
        f << %Q(<button type="submit" class="button">Sign in</button>)
      end

      actual.should eq(expected)
    end
  end

  describe ".form_html_attributes" do
    it "returns correct attributes" do
      attrs = StringHash.new

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

        if ["checkbox", "radio"].include?(field_type)
          attrs["class"] = field_type
        else
          attrs["class"] = "label is-normal"
        end

        theme.label_html_attributes(html_attrs: StringHash.new, field_type: field_type, has_errors?: false).should eq(attrs)
      end
    end

    describe ".build_html_help_text" do
      it "returns correct #{field_type} attributes" do
        expected = "<p class=\"help\">foobar</p>"

        attrs = StringHash.new

        theme.build_html_help_text(html_attrs: attrs, field_type: field_type, help_text: "foobar").should eq(expected)
      end
    end

    describe ".build_html_error" do
      it "returns correct #{field_type} attributes" do
        expected = "<p class=\"help is-danger\">foobar</p>"

        attrs = StringHash.new

        theme.build_html_error(html_attrs: attrs, field_type: field_type, error: "foobar").should eq(expected)
      end
    end
  end

end
