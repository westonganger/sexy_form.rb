require "../../spec_helper"

theme = FormBuilder::Themes::Bootstrap4Inline

describe FormBuilder::Themes do

  describe ".theme_name" do
    it "works by default" do
      FormBuilder::Themes.theme_name.should eq("themes")
    end

    it "works with custom" do
      theme.theme_name.should eq("bootstrap_4_inline")
    end
  end

  describe ".subclasses" do
    it "Comes with default themes" do
      subclasses = [FormBuilder::Themes::Bootstrap2Horizontal, FormBuilder::Themes::Bootstrap2Inline, FormBuilder::Themes::Bootstrap2Vertical, FormBuilder::Themes::Bootstrap3Horizontal, FormBuilder::Themes::Bootstrap3Inline, FormBuilder::Themes::Bootstrap3Vertical, FormBuilder::Themes::Bootstrap4Horizontal, FormBuilder::Themes::Bootstrap4Inline, FormBuilder::Themes::Bootstrap4Vertical, FormBuilder::Themes::BulmaHorizontal, FormBuilder::Themes::BulmaVertical, FormBuilder::Themes::Default, FormBuilder::Themes::Foundation, FormBuilder::Themes::Materialize, FormBuilder::Themes::Milligram, FormBuilder::Themes::SemanticUIInline, FormBuilder::Themes::SemanticUIVertical]

      FormBuilder::Themes.subclasses.should eq(subclasses)

      expected = ["bootstrap_2_horizontal", "bootstrap_2_inline", "bootstrap_2_vertical", "bootstrap_3_horizontal", "bootstrap_3_inline", "bootstrap_3_vertical", "bootstrap_4_horizontal", "bootstrap_4_inline", "bootstrap_4_vertical", "bulma_horizontal", "bulma_vertical", "default", "foundation", "materialize", "milligram", "semantic_ui_inline", "semantic_ui_vertical"]

      subclasses.map{|x| x.theme_name}.should eq(expected)
    end
  end

  describe ".from_name" do
    it "works correctly" do
      FormBuilder::Themes.from_name("bootstrap_4_inline").should eq(theme)
    end

    it "fails correctly" do
      expect_raises(ArgumentError) do
        FormBuilder::Themes.from_name("invalid_theme")
      end
    end
  end

  describe "Kitchen Sink" do
    FormBuilder::Themes.subclasses.each do |theme_class|
      b = FormBuilder::Builder.new(theme: theme_class.new)

      FIELD_TYPES.each do |field_type|
        it "theme: #{theme_class.name}, field_type: #{field_type}" do
          if field_type == "select"
            b.field type: field_type, collection: {options: [["foo", "bar"]]}
          else
            b.field type: field_type
          end
        end
      end
    end
  end

end
