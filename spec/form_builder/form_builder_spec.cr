require "../../spec_helper"

### For Testing Private/Protected Methods
module FormBuilder
  def self._content(element_name : Symbol, content : String, options : OptionHash)
    content(element_name: element_name, content: content, options: options)
  end

  def self._content(element_name : Symbol, options : OptionHash, &block)
    content(element_name: element_name, options: options, &block)
  end
end

describe FormBuilder do

  describe ".form" do
    it "allows no block" do
      result = FormBuilder.form(action: "/products", method: :post, style: "margin-top: 20px;", "data-foo": "bar")

      expected = "<form href=\"/products\" id=\"myForm\" method=\"post\"><input type=\"text\" name=\"name\" id=\"name\"/></form>"

      result.should eq(expected)
    end

    it "allows basic usage" do
      result = FormBuilder.form(theme: :bootstrap_4, action: "/products", method: :post, style: "margin-top: 20px;", "data-foo": "bar") do

      end

      expected = "<form href=\"/products\" id=\"myForm\" method=\"post\"><input type=\"text\" name=\"name\" id=\"name\"/></form>"

      result.should eq(expected)
    end

    it "work with errors" do
      errors : Hash(String, Array(String)) = {"name" => ["already taken"], "sku" => ["invalid format", "cannot be blank"]}

      result = FormBuilder.form(theme: :bootstrap_4, errors: errors) do |f|
        f.input name: "name", type: :string
        f.input name: "sku", type: :string
      end

      expected = "<form id=\"myForm\" method=\"post\"><input type=\"text\" name=\"name\" id=\"name\"/></form>"

      result.should eq(expected)
    end

    it "allows for nested input fields" do
      result = FormBuilder.form(id: "myForm") do |f|
        f.input name: :name, type: :string
      end

      expected = "<form id=\"myForm\" method=\"post\"><input type=\"text\" name=\"name\" id=\"name\"/></form>"

      result.should eq(expected)
    end

    it "sets up form for multipart" do
      result = FormBuilder.form(action: "/test/1", id: "myForm", multipart: true)

      expected = %(<form action="/test/1" id="myForm" multipart="true" method="post" enctype="multipart/form-data"></form>)

      result.should eq(expected)
    end
  end

  describe ".content" do
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

  it "exposes a VERSION" do
    FormBuilder::VERSION.should be_a(String)
  end

end
