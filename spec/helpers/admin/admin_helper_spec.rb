require 'spec_helper'

describe Admin::AdminHelper do
  describe "#breadcrumbs" do
    it "writes out a list of links from tuples" do
      results = helper.breadcrumbs(["Foo", '/'], ["Baz", "http://baz.ca"])
      results.should == %{&#8250; <a href="/">Foo</a> &#8250; <a href="http://baz.ca">Baz</a>}
    end

    it "writes string arguments as just text" do
      results = helper.breadcrumbs("C", ["A", '/'], "B")
      results.should == %{&#8250; C &#8250; <a href="/">A</a> &#8250; B}
    end
  end

  describe "#tabs" do
    it "returns active tab for current action controller" do
       tab_active?('/admin/studios/1/movies/1/promotions', 'promotions').should == 'tabOn'
       tab_active?('/admin/studios/1/movies/1/edit', 'movie').should == 'tabOn'
       tab_active?('/admin/studios/1/movies/1/edit', 'promotions').should == ''
    end
  end

end