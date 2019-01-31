require "../../spec_helper"

describe FormBuilder do

  describe "#form" do
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
end
