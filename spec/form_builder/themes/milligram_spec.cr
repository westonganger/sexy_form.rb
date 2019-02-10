require "../../spec_helper"
require "./theme_spec_helper"

theme_klass = FormBuilder::Themes::Milligram
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

  describe "FormBuilder.form" do
    it "matches docs example with labels" do
      expected = String.build do |str|
        str << %(<form method="post">)
          str << "<div>"
            str << %(<label for="nameField">Name</label>)
            str << %(<input type="text" placeholder="Name" name="nameField" id="nameField">)
          str << "</div>"

          str << "<div>"
            str << %(<label for="ageRangeField">Age Range</label>)
            str << %(<select name="ageRangeField" id="ageRangeField">)
              str << %(<option value="0-13">0-13</option>)
              str << %(<option value="14-17">14-17</option>)
              str << %(<option value="18-23">18-23</option>)
              str << %(<option value="24+">24+</option>)
            str << %(</select>)
          str << "</div>"

          str << "<div>"
            str << %(<label for="commentField">Comment</label>)
            str << %(<textarea placeholder="Hello World" name="commentField" id="commentField"></textarea>)
          str << "</div>"

          str << %(<div class="float-right">)
            str << "<div>"
              str << %(<input type="checkbox" name="confirmField" id="confirmField">)
              str << %(<label class="label-inline" for="confirmField">Confirm?</label>)
            str << %(</div>)
          str << "</div>"

          str << %(<input type="submit" class="button-primary" value="Send">)
        str << %(</form>)
      end

      actual = FormBuilder.form(theme: theme_klass.theme_name) do |f|
        f << f.field(type: :text, name: :nameField, label: "Name", input_html: {placeholder: "Name"})
        f << f.field(type: :select, name: :ageRangeField, label: "Age Range", collection: {options: ["0-13","14-17","18-23","24+"]})
        f << f.field(type: :textarea, name: :commentField, label: "Comment", input_html: {placeholder: "Hello World"})
        f << %(<div class="float-right">)
          f << f.field(type: :checkbox, name: :confirmField, label: "Confirm?")
        f << "</div>"
        f << %(<input type="submit" class="button-primary" value="Send">)
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
          attrs["class"] = "label-inline"
        end

        theme.label_html_attributes(html_attrs: StringHash.new, field_type: field_type).should eq(attrs)
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
