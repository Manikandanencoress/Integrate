require "spec_helper"

describe "/admin" do
  it "routes to the studios index" do
    { :get => "/admin" }.should route_to(:controller => "admin/studios", :action => "index")
  end

  describe "sign in pages" do
    it "routes to the custom devise controller" do
      { :get => '/admin/sign_in'}.should route_to(:controller => "admin/foos", :action => "new")
    end
  end

end