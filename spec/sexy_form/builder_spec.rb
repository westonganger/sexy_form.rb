require "spec_helper"

builder = FormBuilder::Builder.new

describe FormBuilder::Builder do

  describe "#initialize" do
    it "defaults to theme: :default" do
      builder.theme.class.should eq(FormBuilder::Themes::Default)
    end

    it "allows string :theme name" do
      FormBuilder::Builder.new(theme: "bootstrap_4_inline").theme.class.should eq(FormBuilder::Themes::Bootstrap4Inline)
    end

    it "allows class instance :theme" do
      expected = FormBuilder::Themes::Bootstrap4Inline
      FormBuilder::Builder.new(theme: expected.new).theme.class.should eq(expected)
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

        it "does not allow collection option" do
          expect_raises(ArgumentError) do
            builder.field(type: field_type, label: false, name: "my-great-text-input", input_html: {foo: :bar}, collection: {options: ["foo", "bar"]})
          end
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
          expect_raises(ArgumentError) do
            builder.field(type: :select, label: false, name: "my-great-text-input", input_html: {foo: :bar})
          end
        end

        it "all supported keys work" do
          builder.field(type: :select, collection: {options: ["foo", "bar", "foobar"], selected: ["bar"], disabled: ["foobar"], include_blank: "blank"})

          builder.field(type: :select, collection: {options: ["foo", "bar", "foobar"], selected: "bar", disabled: "foobar", include_blank: true})

          builder.field(type: :select, collection: {options: "foobar"})
        end

        it "fails correctly" do
          expect_raises(ArgumentError) do
            builder.field(type: :select, collection: {selected: "bar"})
          end

          expect_raises(ArgumentError) do
            builder.field(type: :select, collection: {options: ["foo", "bar", "foobar"], foobar: "error"})
          end

          expect_raises(ArgumentError) do
            builder.field(type: :select, collection: {options: "foobar", selected: "asd"})
          end

          expect_raises(ArgumentError) do
            builder.field(type: :select, collection: {options: "foobar", disabled: "asd"})
          end

          expect_raises(ArgumentError) do
            builder.field(type: :select, collection: {options: "foobar", include_blank: "asd"})
          end
        end
      end
    end
  end

end
