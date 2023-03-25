require "spec_helper"

describe SexyForm do

  it "exposes a VERSION" do
    SexyForm::VERSION.should be_a(String)
  end

  describe "form" do
    it "allows no block" do
      result = SexyForm.form(action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo": "bar"})

      expected = "<form style=\"margin-top: 20px;\" data-foo=\"bar\" method=\"post\"></form>"

      result.should eq(expected)
    end

    it "allows basic usage" do
      result = SexyForm.form(theme: :bootstrap_4_inline, action: "/products", method: :post, form_html: {style: "margin-top: 20px;", "data-foo": "bar"}) do

      end

      expected = "<form style=\"margin-top: 20px;\" data-foo=\"bar\" class=\"form-inline\" method=\"post\"></form>"

      result.should eq(expected)
    end

    it "allows for nested input fields" do
      result = SexyForm.form(form_html: {"id" => "myForm"}) do |f|
        f << f.field(name: :name, type: :text)
      end

      expected = "<form id=\"myForm\" method=\"post\"><div><label for=\"name\">Name</label><input type=\"text\" name=\"name\" id=\"name\"></div></form>"

      result.should eq(expected)
    end

    it "sets up form for multipart" do
      result = SexyForm.form(action: "/test/1", form_html: {id: "myForm", multipart: true})

      expected = "<form id=\"myForm\" method=\"post\" enctype=\"multipart/form-data\"></form>"

      result.should eq(expected)
    end

    it "String keys take precedence over Symbol keys on :form_html argument" do
      result = SexyForm.form(action: "/test/1", form_html: {"id" => "string", :id => "symbol"})

      result.include?("string").should eq(true)
      result.include?("symbol").should eq(false)
    end
  end

  describe "build_html_attr_string" do
    it "removes nil and blank values" do
      expect(SexyForm.build_html_attr_string({foo: nil, bar: " "})).to eq("")
    end

    it "works with symbol values" do
      expect(SexyForm.build_html_attr_string({foo: :bar})).to eq(%Q(foo="bar"))
    end

    it "strips present values" do
      expect(SexyForm.build_html_attr_string({foo: "bar "})).to eq(%Q(foo="bar"))
    end
  end

  describe "build_html_element" do
    it "works without attrs" do
      expect(SexyForm.build_html_element(:span, {})).to eq("<span>")
    end

    it "works with attrs" do
      expect(SexyForm.build_html_element(:span, {foo: :bar})).to eq(%Q(<span foo="bar">))
    end
  end

end
