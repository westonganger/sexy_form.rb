require "spec_helper"
require_relative "theme_spec_helper"

describe SexyForm::Themes::BaseTheme do

  describe ".theme_name" do
    it "works by default" do
      SexyForm::Themes::BaseTheme.theme_name.should eq("base_theme")
    end

    it "works with custom" do
      SexyForm::Themes::Bootstrap4Inline.theme_name.should eq("bootstrap_4_inline")
    end
  end

end
