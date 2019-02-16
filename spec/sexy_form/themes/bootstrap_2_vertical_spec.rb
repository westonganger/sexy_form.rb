require_relative "../../spec_helper"
require_relative "./theme_spec_helper"

theme_klass = SexyForm::Themes::Bootstrap2Vertical
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

  describe "SexyForm.form" do
    it "matches docs example" do
      expected = build_string do |str|
        str << %Q(<form method="post">)
          str << %Q(<div class="control-group">)
            str << %Q(<label class="control-label" for="inputEmail">Email</label>)
            str << %Q(<div class="controls">)
              str << %Q(<input type="text" id="inputEmail" placeholder="Email">)
            str << %Q(</div>)
          str << %Q(</div>)
          str << %Q(<div class="control-group">)
            str << %Q(<label class="control-label" for="inputPassword">Password</label>)
            str << %Q(<div class="controls">)
              str << %Q(<input type="password" id="inputPassword" placeholder="Password">)
            str << %Q(</div>)
          str << %Q(</div>)
          str << %Q(<div class="control-group">)
            str << %Q(<div class="controls">)
              str << %Q(<label class="checkbox">)
                str << %Q(<input type="checkbox"> Remember me)
              str << %Q(</label>)
            str << %Q(</div>)
          str << %Q(</div>)
          str << %Q(<button type="submit" class="btn">Sign in</button>)
        str << %Q(</form>)
      end

      actual = SexyForm.form(theme: theme_klass.theme_name) do |f|
        f << f.field(type: :text, label: "Email", input_html: {id: "inputEmail", placeholder: "Email"})
        f << f.field(type: :password, label: "Password", input_html: {id: "inputPassword", placeholder: "Password"})
        f << f.field(type: :checkbox, label: "Remember me")
        f << %Q(<button type="submit" class="btn">Sign in</button>)
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

        if ["checkbox", "radio"].include?(field_type)
          attrs["class"] = field_type
        else
          attrs["class"] = "control-label"
        end

        theme.label_html_attributes(html_attrs: {}, field_type: field_type, has_errors: false).should eq(attrs)
      end
    end

    describe ".build_html_help_text" do
      it "returns correct #{field_type} attributes" do
        expected = "<span class=\"help-block\">foobar</span>"

        attrs = {}

        theme.build_html_help_text(html_attrs: attrs, field_type: field_type, help_text: "foobar").should eq(expected)
      end
    end

    describe ".build_html_error" do
      it "returns correct #{field_type} attributes" do
        expected = "<span class=\"help-block\">foobar</span>"

        attrs = {}

        theme.build_html_error(html_attrs: attrs, field_type: field_type, error: "foobar").should eq(expected)
      end
    end
  end

end
