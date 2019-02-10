require "../../spec_helper"

### For Testing Private/Protected Methods
module FormBuilder
  def self._content(element_name : String, attrs : StringHash = StringHash.new, &block)
    content(element_name: element_name, attrs: attrs) do
      yield
    end
  end
end

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
      # TODO
    end
  end

  describe ".content" do
    it "accepts a block as input" do
      result = FormBuilder._content(element_name: "div", attrs: {"id" => "foo"}) do
        String.build do |str|
          str << "Hello"
        end
      end

      result.should eq("<div id=\"foo\">Hello</div>")
    end

    it "allows nested blocks" do
      result = FormBuilder._content(element_name: "div", attrs: {"id" => "foo"}) do
        FormBuilder._content(element_name: "span", attrs: {"id" => "bar"}) do
          "Hello"
        end
      end

      result.should eq("<div id=\"foo\"><span id=\"bar\">Hello</span></div>")
    end
  end

end
