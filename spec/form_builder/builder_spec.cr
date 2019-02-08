require "../../spec_helper"

builder = FormBuilder::Builder.new

describe FormBuilder::Builder do

  describe "#initialize" do

  end

  describe "#field" do
    it "does not allow incorrect types" do
      expect_raises(ArgumentError) do
        builder.field(type: "submit", name: :foobar)
      end
    end

    describe "input fields" do

      INPUT_TYPES.each do |field_type|
        it "works for type: #{field_type}" do
          expected = "<div><input type=\"#{field_type}\" foo=\"bar\" name=\"my-great-text-input\" id=\"my-great-text-input\"></div>"

          builder.field(type: field_type, label: false, name: "my-great-text-input", input_html: {foo: :bar}).should eq(expected)
        end
      end

    end

    describe "select fields" do
      it "works for select fields" do
        expected = "<div><select foo=\"bar\" name=\"my-great-text-input\" id=\"my-great-text-input\"><option value=\"foo\">foo</option><option value=\"bar\">bar</option></select></div>"

        builder.field(type: :select, label: false, name: "my-great-text-input", input_html: {foo: :bar}, collection: {options: ["foo", "bar"]}).should eq(expected)
      end

      it "allows :selected option" do
        # TODO
      end

      it "allows :disabled option" do
        # TODO
      end
    end
  end

end
