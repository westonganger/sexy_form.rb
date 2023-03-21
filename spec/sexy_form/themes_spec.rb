require_relative "../spec_helper"

theme = SexyForm::Themes::Bootstrap4Inline

describe SexyForm::Themes do

  describe ".classes" do
    it "Comes with default themes" do
      classes = [SexyForm::Themes::Bootstrap2Horizontal, SexyForm::Themes::Bootstrap2Inline, SexyForm::Themes::Bootstrap2Vertical, SexyForm::Themes::Bootstrap3Horizontal, SexyForm::Themes::Bootstrap3Inline, SexyForm::Themes::Bootstrap3Vertical, SexyForm::Themes::Bootstrap4Horizontal, SexyForm::Themes::Bootstrap4Inline, SexyForm::Themes::Bootstrap4Vertical, SexyForm::Themes::BulmaHorizontal, SexyForm::Themes::BulmaVertical, SexyForm::Themes::Default, SexyForm::Themes::Foundation, SexyForm::Themes::Materialize, SexyForm::Themes::Milligram, SexyForm::Themes::SemanticUIInline, SexyForm::Themes::SemanticUIVertical]

      SexyForm::Themes.classes.should eq(classes)

      expected = ["bootstrap_2_horizontal", "bootstrap_2_inline", "bootstrap_2_vertical", "bootstrap_3_horizontal", "bootstrap_3_inline", "bootstrap_3_vertical", "bootstrap_4_horizontal", "bootstrap_4_inline", "bootstrap_4_vertical", "bulma_horizontal", "bulma_vertical", "default", "foundation", "materialize", "milligram", "semantic_ui_inline", "semantic_ui_vertical"]

      classes.map{|x| x.theme_name}.should eq(expected)
    end
  end

  describe ".from_name" do
    it "works correctly" do
      SexyForm::Themes.from_name("bootstrap_4_inline").should eq(theme)
    end

    it "fails correctly" do
      expect {
        SexyForm::Themes.from_name("invalid_theme")
      }.to raise_exception(ArgumentError)
    end
  end

  describe "Kitchen Sink" do
    SexyForm::Themes.classes.each do |theme_class|
      b = SexyForm::Builder.new(theme: theme_class.new)

      TESTED_FIELD_TYPES.each do |field_type|
        it "theme: #{theme_class.name}, field_type: #{field_type}" do
          if field_type == "select"
            actual = b.field type: :select, name: :foobar, label: "Hello", help_text: "World", errors: ["error1", "error2"], input_html: {class: "foo"}, label_html: {class: "foo"}, wrapper_html: {class: "foo"}, help_text_html: {class: "foo"}, error_html: {class: "foo"}, collection: {options: [["foo", "bar"], "foobar"], selected: "foobar", disabled: "other", include_blank: true}
          else
            actual = b.field type: field_type, name: :foobar, label: "Hello", help_text: "World", value: "foo", errors: ["error1", "error2"], input_html: {class: "foo"}, label_html: {class: "foo"}, wrapper_html: {class: "foo"}, help_text_html: {class: "foo"}, error_html: {class: "foo"}
          end

          ### Ensure No Incorrect/Unparenthesized Ternary Values
          actual.include?("true").should eq(false)
          actual.include?("false").should eq(false)
          actual.include?("empty?").should eq(false)
        end
      end
    end
  end

end
