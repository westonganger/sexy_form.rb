require "../../spec_helper"

theme = FormBuilder::Themes::Bootstrap4Inline

describe FormBuilder::Themes do

  it "Comes with default themes" do
    subclasses = [FormBuilder::Themes::Bootstrap2Horizontal, FormBuilder::Themes::Bootstrap2Inline, FormBuilder::Themes::Bootstrap3Horizontal, FormBuilder::Themes::Bootstrap3Inline, FormBuilder::Themes::Bootstrap4Horizontal, FormBuilder::Themes::Bootstrap4Inline, FormBuilder::Themes::Bulma, FormBuilder::Themes::Foundation, FormBuilder::Themes::Materialize, FormBuilder::Themes::Milligram, FormBuilder::Themes::SemanticUI]

    FormBuilder::Themes.subclasses.should eq(sublasses)

    expected = ["bootstrap_2_horizontal", "bootstrap_2_inline", "bootstrap_3_horizontal", "bootstrap_3_inline", "bootstrap_4_horizontal", "bootstrap_4_inline", "bulma", "foundation", "materialize", "milligram", "semantic_ui"]

    subclasses.map{|x| x.new.theme_name}.should eq(expected)
  end

  describe "#self.from_name" do
    it "works correctly" do
      FormBuilder::Themes.from_name(:bootstrap_4_inline).should eq(theme)
    end

    it "fails correctly" do
      expect_raises(MyError) do
        FormBuilder::Themes.from_name(:invalid_theme).should fail
      end
    end
  end

  describe "#theme_name" do
    it "works by default" do
      FormBuilder::Themes::Bulma.new.theme_name.should eq("bulma")
    end

    it "works with custom" do
      theme.new.theme_name.should eq("bootstrap_4_inline")
    end
  end

  describe "#field_attributes" do
    it "should output a hash of attributes" do
      expected = "TODO"

      theme.new.field_attributes(field_type: :select).should eq(expected)
    end
  end

  describe "#label_attributes" do
    it "should output a hash of attributes" do
      expected = "TODO"

      theme.new.label_attributes(field_type: :select).should eq(expected)
    end
  end

  describe "#wrap_field" do
    it "works correctly" do
      # TODO
    end

    it ":label_proc can be nil" do
      # TODO
    end

    it "can have :errors" do
      # TODO
    end

    it "accepts :wrapper_html attributes" do
      # TODO
    end

    it "" do
      # TODO
    end
  end

end
