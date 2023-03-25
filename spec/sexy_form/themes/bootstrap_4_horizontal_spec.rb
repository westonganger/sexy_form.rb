require_relative "../../spec_helper"
require_relative "./theme_spec_helper"

theme_klass = SexyForm::Themes::Bootstrap4Horizontal
theme = theme_klass.new

describe SexyForm::ActionViewHelpers do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("bootstrap_4_horizontal")
    end
  end

  describe ".wrap_field" do
    it "works" do

    end
  end

  describe "helpers.sexy_form" do
    it "matches docs example" do
      expected = build_string do |str|
        str << %Q(<form method="post">)
          str << %Q(<div class="form-group row">)
            str << %Q(<label class="col-sm-3 col-form-label" for="email">Email</label>)
            str << %Q(<div class="col-sm-9">)
              str << %Q(<input type="text" class="form-control" name="email" id="email">)
            str << %Q(</div>)
          str << %Q(</div>)

          str << %Q(<div class="form-group row">)
            str << %Q(<label class="col-sm-3 col-form-label" for="password">Password</label>)
            str << %Q(<div class="col-sm-9">)
              str << %Q(<input type="password" class="form-control" name="password" id="password">)
            str << %Q(</div>)
          str << %Q(</div>)

          str << %Q(<div class="form-group row">)
            str << %Q(<div class="col-sm-offset-3 col-sm-9">)
              str << %Q(<div class="form-check">)
                str << %Q(<input type="checkbox" class="form-check-input" name="remember_me" id="remember_me">)
                str << %Q(<label class="form-check-label" for="remember_me">Remember Me</label>)
              str << %Q(</div>)
            str << %Q(</div>)
          str << %Q(</div>)

          str << %Q(<button type="submit" class="btn btn-default">Sign in</button>)
        str << %Q(</form>)
      end

      actual = helpers.sexy_form(theme: theme_klass.new(column_classes: ["col-sm-3", "col-sm-9"])) do |f|
        f << f.field(type: :text, name: :email)
        f << f.field(type: :password, name: :password)
        f << f.field(type: :checkbox, name: :remember_me)
        f << %Q(<button type="submit" class="btn btn-default">Sign in</button>)
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

  TESTED_FIELD_TYPES.each do |field_type|
    describe ".input_html_attributes" do
      it "returns correct #{field_type} attributes" do
        attrs = {}

        case field_type
        when "checkbox", "radio"
          attrs["class"] = "form-check-input"
        when "file"
          attrs["class"] = "form-control-file"
        else
          attrs["class"] = "form-control"
        end

        theme.input_html_attributes(html_attrs: {}, field_type: field_type, has_errors: false).should eq(attrs)
      end
    end

    describe ".label_html_attributes" do
      it "returns correct #{field_type} attributes" do
        attrs = {}

        if ["checkbox", "radio"].include?(field_type)
          attrs["class"] = "form-check-label"
        else
          attrs["class"] = "col-sm-3 col-form-label"
        end

        theme.label_html_attributes(html_attrs: {}, field_type: field_type, has_errors: false).should eq(attrs)
      end
    end

    describe ".build_html_help_text" do
      it "returns correct #{field_type} attributes" do
        expected = "<small class=\"form-text\">foobar</small>"

        attrs = {}

        theme.build_html_help_text(html_attrs: attrs, field_type: field_type, help_text: "foobar").should eq(expected)
      end
    end

    describe ".build_html_error" do
      it "returns correct #{field_type} attributes" do
        expected = "<div class=\"invalid-feedback\">foobar</div>"

        attrs = {}

        theme.build_html_error(html_attrs: attrs, field_type: field_type, error: "foobar").should eq(expected)
      end
    end
  end

end
