require 'spec_helper'

describe StudiosHelper do
  describe ".copyright_for" do
    let(:studio) { Factory.build :studio, :copyright_notice => "abc" }

    it "doesn't blow up when passed an empty template" do
      studio.copyright_notice = ""
      helper.copyright_for(studio).should == "\n"
    end

    it "runs the template through mustache using the studio's attributes" do
      studio.copyright_notice = "abc {{name}} def"
      helper.copyright_for(studio).should match(/abc #{studio.name} def/)
    end

    it "runs the mustache results through markdown" do
      studio.copyright_notice = "abc **{{name}}** def"
      helper.copyright_for(studio).should match(/abc <strong>#{studio.name}<\/strong> def/)
    end

    it "converts all links to use target _top" do
      studio.copyright_notice = "abc [Some Link](http://google.com) def"
      expected = %{abc <a href="http://google.com" target="_top">Some Link</a> def}
      helper.copyright_for(studio).should match(expected)
    end

    it "outputs safe html" do
      studio.copyright_notice = "[Link](http://google.com)"
      helper.copyright_for(studio).should be_html_safe
    end
  end

end
