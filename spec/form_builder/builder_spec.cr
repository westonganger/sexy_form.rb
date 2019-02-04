require "../../spec_helper"

builder = FormBuilder::Builder.new(theme: :bootstrap_4_inline)

### For Testing Private/Protected Methods
class FormBuilder::Builder
  def _input(name : (String | Symbol), type : (String | Symbol), options : OptionHash? = OptionHash.new)
    input(name: name, type: type, options: options)
  end

  def _select_field(name : (String | Symbol), collection : (Array(Array) | Array | Range), selected : Array(String)? = [] of String, disabled : Array(String)? = [] of String, options : OptionHash? = OptionHash.new)
    select_field(name: name, collection: collection, selected: selected, disabled: disabled, options: options)
  end

  def _css_safe(value)
    css_safe(value)
  end
end

describe FormBuilder::Builder do

  describe "#initialize" do

  end

  describe "#css_safe" do
    it "creates safe id from bracketed name" do
      builder._css_safe("test[name]").should eq("test_name")
    end

    it "shouldn't put more than underscores in a row or have ending or leading underscores" do
      builder._css_safe(" david[bowie!]{rules}").should eq("david_bowie_rules")
    end
  end

  describe "#input" do
    it "works" do
      expected = %(<input type="text" name="my-great-text-input" id="my-great-text-input" foo="bar">)

      opts = OptionHash.new
      opts[:foo] = :bar

      builder._input(type: :text, name: "my-great-text-input", options: opts).should eq(expected)
    end

    it "options[:name] takes precedence over :name argument" do
      expected = %(<input type="text" name="bar" id="foo" foo="bar">)

      opts = OptionHash.new
      opts[:name] = "bar"

      builder._input(type: :text, name: "foo", options: opts).should eq(expected)
    end

    it "options[:id] takes precedence over default id" do
      expected = %(<input type="text" name="foo" id="bar">)

      opts = OptionHash.new
      opts[:id] = "bar"

      builder._input(type: :text, name: "foo", options: opts).should eq(expected)
    end
  end

  describe "#select_field" do
    it "works" do
      expected = %(<input type="text" name="my-great-text-input" id="my-great-text-input" foo="bar">)

      opts = OptionHash.new
      opts[:foo] = :bar

      collection = [] of String

      builder._select_field(name: "my-great-text-input", collection: collection, options: opts).should eq(expected)
    end

    it "options[:name] takes precedence over :name argument" do
      expected = %(<input type="text" name="bar" id="foo" foo="bar">)

      opts = OptionHash.new
      opts[:name] = "bar"

      collection = [] of String

      builder._select_field(name: "foo", collection: collection, options: opts).should eq(expected)
    end

    it "options[:id] takes precedence over default id" do
      expected = %(<input type="text" name="foo" id="bar">)

      opts = OptionHash.new
      opts[:id] = "bar"

      collection = [] of String

      builder._select_field(name: "foo", collection: collection, options: opts).should eq(expected)
    end

    it "allows :selected option" do
    end

    it "allows :disabled option" do

    end
  end

  describe "#field" do
    describe "type: :checkbox" do
      it "works" do
        # TODO
        builder.field(type: :checkbox, name: :foobar)
      end

    #   it "creates a check_box with yes/no" do
    #     expected = "<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"yes\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"no\"/>"
    #     check_box(:allowed, checked_value: "yes", unchecked_value: "no").should eq(expected)
    #   end

    #   it "creates a check_box with only value" do
    #     expected = "<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/>"
    #     check_box(:allowed).should eq(expected)
    #   end

    #   it "marks box as checked" do
    #     expected = "<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\" checked=\"checked\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/>"
    #     check_box(:allowed, checked: true).should eq(expected)
    #   end

    #   it "marks box as not checked" do
    #     expected = "<input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/>"
    #     check_box(:allowed, checked: false).should eq(expected)
    #   end
    end

    describe "type: :file" do
      it "works" do
        # TODO
        builder.field(type: :file, name: :foobar)
      end

    #   it "main param works with string" do
    #     expected = "<input type=\"file\" name=\"my-great-file-input\" id=\"my-great-file-input\"/>"
    #     file_field("my-great-file-input").should eq(expected)
    #   end

    #   it "main param works with symbol" do
    #     file_field(:name).should eq("<input type=\"file\" name=\"name\" id=\"name\"/>")
    #   end

    #   it "style value works" do
    #     file_field(:name, style: "color: white;").should eq("<input type=\"file\" name=\"name\" id=\"name\" style=\"color: white;\"/>")
    #   end
    end

    describe "type: :hidden" do
      it "works" do
        # TODO
        builder.field(type: :hidden, name: :foobar)
      end

    #   it "creates a hidden field" do
    #     hidden_field(:token).should eq("<input type=\"hidden\" name=\"token\" id=\"token\"/>")
    #   end
    end

    describe "type: :password" do
      it "works" do
        # TODO
        builder.field(type: :password, name: :foobar)
      end
    end

    describe "type: :radio" do
      it "works" do
        # TODO
        builder.field(type: :radio, name: :foobar)
      end
    end

    describe "type: :select" do
      it "works" do
        # TODO
        builder.field(type: :select, name: :foobar)
      end

    #   it "creates a select_field with two dimension arrays" do
    #     select_field(:age, [[1, "A"], [2, "B"]]).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>")
    #   end

    #   it "creates a select_field with array of hashes" do
    #     select_field(:age, [{:"1" => "A"}, {:"2" => "B"}]).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>")
    #   end

    #   it "creates a select_field with a hash" do
    #     select_field(:age, {:"1" => "A", :"2" => "B"}).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>")
    #   end

    #   it "creates a select_field with a hash and id" do
    #     expected = "<select id=\"age_of_thing\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>"
    #     select_field(:age, {:"1" => "A", :"2" => "B"}, id: "age_of_thing").should eq(expected)
    #   end

    #   it "creates a select_field with a named tuple" do
    #     select_field(:age, {"1": "A", "2": "B"}).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>")
    #   end

    #   it "creates a select_field with a namedtuple and id" do
    #     expected = "<select id=\"age_of_thing\" name=\"age\"><option value=\"1\">A</option><option value=\"2\">B</option></select>"
    #     select_field(:age, {"1": "A", "2": "B"}, id: "age_of_thing").should eq(expected)
    #   end

    #   it "creates a select_field with B selected (String scalar)" do
    #     expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option></select>"
    #     select_field(:age, {"1": "A", "2": "B"}, selected: "2").should eq(expected)
    #   end

    #   it "creates a select_field with B selected (Int32 scalar)" do
    #     expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option></select>"
    #     select_field(:age, {"1": "A", "2": "B"}, selected: 2).should eq(expected)
    #   end

    #   it "creates a select_field with B and C selected (String array)" do
    #     expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option><option value=\"3\" selected=\"selected\">C</option></select>"
    #     select_field(:age, {"1": "A", "2": "B", "3": "C"}, selected: ["2", "3"]).should eq(expected)
    #   end

    #   it "creates a select_field with B and C selected (Int32 array)" do
    #     expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option><option value=\"3\" selected=\"selected\">C</option></select>"
    #     select_field(:age, {"1": "A", "2": "B", "3": "C"}, selected: [2, 3]).should eq(expected)
    #   end

    #   it "creates a select_field with B and C selected (Int32 | String array)" do
    #     expected = "<select name=\"age\"><option value=\"1\">A</option><option value=\"2\" selected=\"selected\">B</option><option value=\"3\" selected=\"selected\">C</option></select>"
    #     select_field(:age, {"1": "A", "2": "B", "3": "C"}, selected: [2, "3"]).should eq(expected)
    #   end

    #   it "creates a select_field with single dimension array" do
    #     select_field(:age, ["A", "B"]).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"A\">A</option><option value=\"B\">B</option></select>")
    #   end

    #   it "creates a select_field with range" do
    #     select_field(:age, collection: 1..5).should eq("<select class=\"age\" id=\"age\" name=\"age\"><option value=\"1\">1</option><option value=\"2\">2</option><option value=\"3\">3</option><option value=\"4\">4</option><option value=\"5\">5</option></select>")
    #   end
    end

    describe "type: :text" do
      it "allows type: :text" do
        # TODO
        builder.field(type: :text, name: :foobar)
      end

      # it "main param works with string" do
      #   expected = "<input type=\"text\" name=\"my-great-text-input\" id=\"my-great-text-input\"/>"
      #   text_field("my-great-text-input").should eq(expected)
      # end

      # it "main param works with symbol" do
      #   text_field(:name).should eq("<input type=\"text\" name=\"name\" id=\"name\"/>")
      # end

      # it "input type with symbol works" do
      #   text_field(:name, type: :password).should eq("<input type=\"password\" name=\"name\" id=\"name\"/>")
      # end

      # it "style value works" do
      #   text_field(:name, style: "color: white;").should eq("<input type=\"text\" name=\"name\" id=\"name\" style=\"color: white;\"/>")
      # end
    end


    describe "type: :textarea" do
      it "works" do
        # TODO
        builder.field(type: :textarea, name: :foobar)
      end

    #   it "creates a text_area" do
    #     text_area(:description, "My Great Textarea").should eq("<textarea name=\"description\" id=\"description\">My Great Textarea</textarea>")
    #   end

    #   it "allows for rows and cols to be specified" do
    #     text_area(:description, "My Great Textarea", cols: 5, rows: 10).should eq("<textarea name=\"description\" id=\"description\" cols=\"5\" rows=\"10\">My Great Textarea</textarea>")
    #   end

    #   it "allows for size to be specified" do
    #     text_area(:description, "My Great Textarea", size: "5x10").should eq("<textarea name=\"description\" id=\"description\" cols=\"5\" rows=\"10\">My Great Textarea</textarea>")
    #   end
    end

    it "does not allow :submit" do
      expect_raises(ArgumentError) do
        builder.field(type: :submit, name: :foobar)
      end
      # TODO
    end
  end

  # describe "#label" do
  #   it "creates with string" do
  #     label("name", "My Label").should eq("<label for=\"name\" id=\"name_label\">My Label</label>")
  #   end

  #   it "creates with symbol" do
  #     label(:name, "My Label").should eq("<label for=\"name\" id=\"name_label\">My Label</label>")
  #   end

  #   it "creates with string and options" do
  #     label(:name, "My Label", class: "label").should eq("<label for=\"name\" id=\"name_label\" class=\"label\">My Label</label>")
  #   end

  #   it "creates with content" do
  #     expected = "<label for=\"name\" id=\"name_label\"><input type=\"checkbox\" name=\"allowed\" id=\"allowed\" value=\"1\"/><input type=\"hidden\" name=\"allowed\" id=\"allowed_default\" value=\"0\"/></label>"
  #     label(:name) do
  #       check_box(:allowed)
  #     end.should eq(expected)
  #   end
  # end


end
