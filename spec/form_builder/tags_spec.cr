require "../../spec_helper"

describe FormBuilder::Tags do

  describe "#content" do
    it "accepts a content string" do
      content(element_name: :span, options: {:id => "bar"}, content: "Hello").should eq("<span id=\"bar\">Hello</span>")
    end

    it "accepts a block as input" do
      result = content(element_name: :div, options: {:id => "foo"}) do
        content(element_name: :span, options: {:id => "bar"}, content: "Hello")
      end

      result.should eq("<div id=\"foo\"><span id=\"bar\">Hello</span></div>")
    end
  end

end
