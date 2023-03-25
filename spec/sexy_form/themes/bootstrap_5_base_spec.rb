require_relative "../../spec_helper"
require_relative "theme_spec_helper"

base_klass = SexyForm::Themes::Bootstrap5Base
theme_klass = SexyForm::Themes::Bootstrap5Horizontal
theme = theme_klass.new

describe theme do

  it "is not a valid theme" do
    expect(base_klass < SexyForm::Themes::BaseTheme).to eq(nil)
    expect{ SexyForm.form(theme: base_klass) }.to raise_error(ArgumentError)
  end

  describe "form_html_attributes" do
    it "returns correct attributes" do
      attrs = {}

      theme.form_html_attributes(html_attrs: {}).should eq(attrs)
    end
  end

  TESTED_FIELD_TYPES.each do |field_type|
    describe "input_html_attributes" do
      it "returns correct #{field_type} attributes" do
        attrs = {}

        case field_type
        when "checkbox", "radio"
          attrs["class"] = "form-check-input"
        when "select"
          attrs["class"] = "form-select"
        else
          attrs["class"] = "form-control"
        end

        theme.input_html_attributes(html_attrs: {}, field_type: field_type, has_errors: false).should eq(attrs)
      end
    end

    describe "label_html_attributes" do
      it "returns correct #{field_type} attributes" do
        attrs = {}

        if ["checkbox", "radio"].include?(field_type)
          attrs["class"] = "form-check-label"
        end

        theme.label_html_attributes(html_attrs: {}, field_type: field_type, has_errors: false).should eq(attrs)
      end
    end

    describe "build_html_help_text" do
      it "returns correct #{field_type} attributes" do
        expected = %Q(<small class="form-text" style="display:block;">foobar</small>)

        attrs = {}

        theme.build_html_help_text(html_attrs: attrs, field_type: field_type, help_text: "foobar").should eq(expected)
      end
    end

    describe "build_html_error" do
      it "returns correct #{field_type} attributes" do
        expected = "<div class=\"invalid-feedback\">foobar</div>"

        attrs = {}

        theme.build_html_error(html_attrs: attrs, field_type: field_type, error: "foobar").should eq(expected)
      end
    end
  end

end
