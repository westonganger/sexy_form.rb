require "spec_helper"

builder = SexyForm::Builder.new

describe SexyForm::Builder do

  describe "#initialize" do
    it "defaults to theme: :default" do
      builder.theme.class.should eq(SexyForm::Themes::Default)
    end

    it "allows string :theme name" do
      SexyForm::Builder.new(theme: "bootstrap_4_inline").theme.class.should eq(SexyForm::Themes::Bootstrap4Inline)
    end

    it "allows class instance :theme" do
      expected = SexyForm::Themes::Bootstrap4Inline
      SexyForm::Builder.new(theme: expected.new).theme.class.should eq(expected)
    end
  end

  describe "#<<" do
    it "supports its own string interpolation" do
      (builder << "foo").should eq("foo")
      (builder << "--").should eq("--")
      (builder << "bar").should eq("bar")

      builder.html_string.should eq("foo--bar")
    end
  end

  describe "#field" do
    it "allows any arbitrary input type" do
      builder.field(type: "submit", name: :foobar)
    end

    describe "input fields" do
      SexyForm::Builder::INPUT_TYPES.each do |field_type|

        it "works for type: #{field_type}" do
          expected = "<div><input type=\"#{field_type}\" foo=\"bar\" name=\"my-great-text-input\" id=\"my-great-text-input\"></div>"

          builder.field(type: field_type, label: false, name: "my-great-text-input", input_html: {foo: :bar}).should eq(expected)
        end

        it "does not allow collection option" do
          expect {
            builder.field(type: field_type, label: false, name: "my-great-text-input", input_html: {foo: :bar}, collection: {options: ["foo", "bar"]})
          }.to raise_exception(ArgumentError)
        end

      end
    end

    describe "select fields" do
      it "works for select fields" do
        expected = "<div><select foo=\"bar\" name=\"my-great-text-input\" id=\"my-great-text-input\"><option value=\"foo\">foo</option><option value=\"bar\">bar</option></select></div>"

        builder.field(type: :select, label: false, name: "my-great-text-input", input_html: {foo: :bar}, collection: {options: ["foo", "bar"]}).should eq(expected)
      end

      describe "collection argument" do
        it "is required" do
          expect {
            builder.field(type: :select, label: false, name: "my-great-text-input", input_html: {foo: :bar})
          }.to raise_exception(ArgumentError)
        end

        it "all supported keys work" do
          builder.field(type: :select, collection: {options: ["foo", "bar", "foobar"], selected: ["bar"], disabled: ["foobar"], include_blank: "blank"})

          builder.field(type: :select, collection: {options: ["foo", "bar", "foobar"], selected: "bar", disabled: "foobar", include_blank: true})

          builder.field(type: :select, collection: {options: "foobar"})
        end

        it "fails correctly" do
          expect {
            builder.field(type: :select, collection: {selected: "bar"})
          }.to raise_exception(ArgumentError)

          expect {
            builder.field(type: :select, collection: {options: ["foo", "bar", "foobar"], foobar: "exception"})
          }.to raise_exception(ArgumentError)

          expect {
            builder.field(type: :select, collection: {options: "foobar", selected: "asd"})
          }.to raise_exception(ArgumentError)

          expect {
            builder.field(type: :select, collection: {options: "foobar", disabled: "asd"})
          }.to raise_exception(ArgumentError)

          expect {
            builder.field(type: :select, collection: {options: "foobar", include_blank: "asd"})
          }.to raise_exception(ArgumentError)
        end
      end
    end
  end

end
