require_relative "../../spec_helper"
require_relative "./theme_spec_helper"

theme_klass = SexyForm::Themes::Milligram
theme = theme_klass.new

describe theme_klass do

  describe ".theme_name" do
    it "is correct" do
      theme_klass.theme_name.should eq("milligram")
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
          str << "<div>"
            str << %Q(<label for="nameField">Name</label>)
            str << %Q(<input type="text" placeholder="Name" name="nameField" id="nameField">)
          str << "</div>"

          str << "<div>"
            str << %Q(<label for="ageRangeField">Age Range</label>)
            str << %Q(<select name="ageRangeField" id="ageRangeField">)
              str << %Q(<option value="0-13">0-13</option>)
              str << %Q(<option value="14-17">14-17</option>)
              str << %Q(<option value="18-23">18-23</option>)
              str << %Q(<option value="24+">24+</option>)
            str << %Q(</select>)
          str << "</div>"

          str << "<div>"
            str << %Q(<label for="commentField">Comment</label>)
            str << %Q(<textarea placeholder="Hello World" name="commentField" id="commentField"></textarea>)
          str << "</div>"

          str << %Q(<div class="float-right">)
            str << "<div>"
              str << %Q(<input type="checkbox" name="confirmField" id="confirmField">)
              str << %Q(<label class="label-inline" for="confirmField">Confirm?</label>)
            str << %Q(</div>)
          str << "</div>"

          str << %Q(<input type="submit" class="button-primary" value="Send">)
        str << "</form>"
      end

      actual = SexyForm.form(theme: theme_klass.theme_name) do |f|
        f << f.field(type: :text, name: :nameField, label: "Name", input_html: {placeholder: "Name"})
        f << f.field(type: :select, name: :ageRangeField, label: "Age Range", collection: {options: ["0-13","14-17","18-23","24+"]})
        f << f.field(type: :textarea, name: :commentField, label: "Comment", input_html: {placeholder: "Hello World"})
        f << %Q(<div class="float-right">)
          f << f.field(type: :checkbox, name: :confirmField, label: "Confirm?")
        f << "</div>"
        f << %Q(<input type="submit" class="button-primary" value="Send">)
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
          attrs["class"] = "label-inline"
        end

        theme.label_html_attributes(html_attrs: {}, field_type: field_type, has_errors: false).should eq(attrs)
      end
    end

    describe ".build_html_help_text" do
      it "returns correct #{field_type} attributes" do
        expected = "<small>foobar</small>"

        attrs = {}

        theme.build_html_help_text(html_attrs: attrs, field_type: field_type, help_text: "foobar").should eq(expected)
      end
    end

    describe ".build_html_error" do
      it "returns correct #{field_type} attributes" do
        expected = "<small style=\"color: red;\">foobar</small>"

        attrs = {}

        theme.build_html_error(html_attrs: attrs, field_type: field_type, error: "foobar").should eq(expected)
      end
    end
  end

end
