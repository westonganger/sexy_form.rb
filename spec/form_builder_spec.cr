require "./spec_helper"

describe FormBuilder do

  it "exposes a VERSION" do
    FormBuilder::VERSION.should be_a(String)
  end

  describe ".form" do
    it "allows no block" do
      result = FormBuilder.form(action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo": "bar"})

      expected = "<form style=\"margin-top: 20px;\" data-foo=\"bar\" method=\"post\"></form>"

      result.should eq(expected)
    end

    it "allows basic usage" do
      result = FormBuilder.form(theme: :bootstrap_4_inline, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo": "bar"}) do

      end

      expected = "<form style=\"margin-top: 20px;\" data-foo=\"bar\" class=\"form-inline\" method=\"post\"></form>"

      result.should eq(expected)
    end

    it "allows for nested input fields" do
      result = FormBuilder.form(form_html: {"id" => "myForm"}) do |f|
        f << f.field name: :name, type: :text
      end

      expected = "<form id=\"myForm\" method=\"post\"><div><label for=\"name\">Name</label><input type=\"text\" name=\"name\" id=\"name\"></div></form>"

      result.should eq(expected)
    end

    it "sets up form for multipart" do
      result = FormBuilder.form(action: "/test/1", form_html: {id: "myForm", multipart: true})

      expected = "<form id=\"myForm\" method=\"post\" enctype=\"multipart/form-data\"></form>"

      result.should eq(expected)
    end

    it "String keys take precedence over Symbol keys on :form_html argument" do
      result = FormBuilder.form(action: "/test/1", form_html: {"id" => "string", :id => "symbol"})

      result.includes?("string").should eq(true)
      result.includes?("symbol").should eq(false)
    end
  end

end
