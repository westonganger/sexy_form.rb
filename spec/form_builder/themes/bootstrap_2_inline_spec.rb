require "../../spec_helper"

field_proc = -> {
  %(<input name="generic">)
}

label_proc = -> {
  %(<label for="generic">Generic</label>)
}

theme = FormBuilder::Themes::Bootstrap2Inline.new

describe FormBuilder::Themes::Bootstrap2Inline do

  describe ".theme_name" do
    it "is correct" do
      theme.theme_name.should eq("bootstrap_2_inline")
    end
  end

  describe ".label_attributes" do
    it "returns correct attributes" do
      expected = {}
      theme.label_attributes(field_type: :text).should eq(expected)
    end
  end

  describe ".field_attributes" do
    it "returns correct attributes" do
      expected = {
        "placeholder" => "Foobar"
      }
      theme.field_attributes(field_type: :text, label_text: "Foobar").should eq(expected)
    end
  end

end
