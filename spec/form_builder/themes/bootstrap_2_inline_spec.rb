require "../../spec_helper"

field_proc = -> {
  %(<input name="generic">)


label_proc = -> {
  %(<label for="generic">Generic</label>)


theme = FormBuilder::Themes::Bootstrap2Inline.new

describe FormBuilder::Themes::Bootstrap2Inline do

  describe ".theme_name" do
    it "is correct" do
      theme.theme_name.should eq("bootstrap_2_inline")
    end
  end

  describe ".wrap_field" do
    it "works" do

    end
  end

  describe "FormBuilder.form" do
    it "matches bootstrap 2 docs example" do
      expected = %(<form class="form-inline">
        <input type="text" class="input-small" placeholder="Email">
        <input type="password" class="input-small" placeholder="Password">
        <label class="checkbox">
          <input type="checkbox"> Remember me
        </label>
        <button type="submit" class="btn">Sign in</button>
      </form>)

      actual = FormBuilder.form(theme: :bootstrap_2_inline) do |f|
        f << f.field(type: :text, label: "Email", input_html: {class: "input-small", "class" => "input-sm")
        f << f.field(type: :password, label: "Password", input_html: {class: "input-small")
        f << f.field(type: :checkbox, label: "Remember Me")
        f << %(<button type="submit" class="btn">Sign in</button>)
      end
        
      actual.should eq(expected)
    end
  end

  describe ".label_attributes" do
    it "returns correct attributes" do
      expected = {
      theme.label_attributes(field_type: :text).should eq(expected)
    end
  end

  describe ".field_attributes" do
    it "returns correct attributes" do
      expected = {
        "placeholder" => "Foobar"
      
      theme.field_attributes(field_type: :text, label_text: "Foobar").should eq(expected)
    end
  end

end
