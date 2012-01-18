require 'spec_helper'

describe ApplicationController do


  context "ip restrictions" do
    let(:us_ip_address) { '204.16.153.246' }
    let(:mexico_ip_address) { '189.200.240.68' }
    let(:canada_ip_address) { '209.226.31.160' }

    controller(ApplicationController) do
      def index
        render :text => "This is only Shown to US IPS"
      end
    end

    def use_ip_address(ip)
      @request.env['REMOTE_ADDR'] = ip
    end

    def get_studio
      get :index, :studio_id => @studio.id
    end

    def ip_should_be_successful(ip)
      use_ip_address ip
      get_studio
      response.should be_success
    end

    def ip_should_redirect(ip)
      use_ip_address ip
      get_studio
      response.should be_redirect
    end

    context "when a studio has no whitelist or blacklist" do
      before { @studio = Factory :studio }
      it "is successful with a US country code" do
        ip_should_be_successful(us_ip_address)
      end
      it "is successful with a non-US country code" do
        ip_should_be_successful(canada_ip_address)
      end
    end

    context "when a studio is given a white list with one country code" do
      before { @studio = Factory :studio, :white_listed_country_codes => "CA" }
      it "is successful when the IP is in the given country code" do
        ip_should_be_successful(canada_ip_address)
      end
      it "redirects when the IP is not in the given country code" do
        ip_should_redirect(mexico_ip_address)
      end
    end

    context "when a studio is given a white list of many country codes" do
      before { @studio = Factory :studio, :white_listed_country_codes => "US,CA" }
      it "is successful when the IP is in one of the given country codes" do
        use_ip_address canada_ip_address
        get_studio
        response.should be_success

        use_ip_address us_ip_address
        get_studio
        response.should be_success
      end
      it "redirects when the IP is in not in the given country codes" do
        use_ip_address mexico_ip_address
        get_studio
        response.should be_redirect
      end
    end

    context "when a studio is given a blacklist of country codes" do
      before { @studio = Factory :studio, :black_listed_country_codes => "US,CA" }
      it "is successful when the IP is not in one of the given countries" do
        ip_should_be_successful mexico_ip_address
      end
      it "redirects when the IP is in the given country" do
        ip_should_redirect us_ip_address
      end
    end

    context "when a studio is given both a whitelist and a blacklist - (ignore the blacklist)" do
      before { @studio = Factory :studio, :white_listed_country_codes => "US", :black_listed_country_codes => "US" }
      it "is successful when the IP is in the whitelist & the blacklist" do
        ip_should_be_successful us_ip_address
      end
      it "redirects when the IP is not in the whitelist or the blacklist" do
        ip_should_redirect canada_ip_address
      end
    end

    context "when the IP is 0.0.0.0" do
      before { @studio = Factory :studio, :white_listed_country_codes => "US", :black_listed_country_codes => "US" }
      it "is successful if the US is in the whitelist" do
        ip_should_be_successful '0.0.0.0'
      end
    end

    context "when the IP is 127.0.0.1" do
      before { @studio = Factory :studio, :white_listed_country_codes => "US", :black_listed_country_codes => "US" }
      it "is successful if the US is in the whitelist" do
        ip_should_be_successful us_ip_address
      end
    end

#
#    it "should not allow IP address for black listed country codes for the studio" do
#      @studio = Factory :studio, :white_listed_country_codes => "US", :black_listed_country_codes => "MX,CA,AU"
#      @request.env['REMOTE_ADDR'] = "1.0.0.1" # Australian!
#      get :index, :studio_id => @studio.id
#      assigns(:studio_id).should == @studio.id
#      response.should redirect_to("/geo_restricted_content.html")
#    end
#
#    it "should allow users with us ip addresses" do
#      @studio = Factory :studio, :white_listed_country_codes => "US", :black_listed_country_codes => "MX,CA,AU"
#      @request.env['REMOTE_ADDR'] = us_ip_address
#      get :index, :studio_id => @studio.id
#      response.status.should == 200
#      response.body.should == "This is only Shown to US IPS"
#    end
#
#    it "should only allow users from canada" do
#      @studio = Factory :studio, :white_listed_country_codes => "CA", :black_listed_country_codes => "MX,AU,US"
#      @request.env['REMOTE_ADDR'] = canada_ip_address
#      get :index, :studio_id => @studio.id
#      ap response
#      response.status.should == 200
#    end
#
#    it "should only allow users from mexico" do
#      @studio = Factory :studio, :white_listed_country_codes => "MX", :black_listed_country_codes => "CA,US"
#      @request.env['REMOTE_ADDR'] = mexico_ip_address
#      get :index, :studio_id => @studio.id
#      response.status.should == 200
#    end
#
#    it "should only allow users from canada and mexico" do
#      @studio = Factory :studio, :white_listed_country_codes => "MX,CA", :black_listed_country_codes => "US"
#      @request.env['REMOTE_ADDR'] = mexico_ip_address
#      get :index, :studio_id => @studio.id
#      response.status.should == 200
#
#      @request.env['REMOTE_ADDR'] = canada_ip_address
#      get :index, :studio_id => @studio.id
#      response.status.should == 200
#
#      @request.env['REMOTE_ADDR'] = us_ip_address
#      get :index, :studio_id => @studio.id
#      response.status.should == 302
#    end
#
#    it "should only allow users from canada and us" do
#      @studio = Factory :studio, :white_listed_country_codes => "CA,US", :black_listed_country_codes => "MX"
#      @request.env['REMOTE_ADDR'] = canada_ip_address
#      get :index, :studio_id => @studio.id
#      response.status.should == 200
#
#      @request.env['REMOTE_ADDR'] = '0.0.0.0'
#      get :index, :studio_id => @studio.id
#      response.status.should == 200
#
#      @request.env['REMOTE_ADDR'] = canada_ip_address
#      get :index, :studio_id => @studio.id
#      response.status.should == 320
#    end
#
#    it "should only allow users from us and mexico" do
#    end
#
#    it "should only allow users from us and canada" do
#
#    end
#
#    it "should only allow users from us and canada and mexico" do
#
#    end
#
#    it "should only allow users from everywhere except us,mexico and canada" do
#
#    end
#
#    it "should allow users from everywhere" do
#
#    end

  end


  describe "#load_facebook_user" do
    controller(ApplicationController) do
      def index
        load_facebook_user
        head(:ok)
      end
    end

    let(:studio) { Factory(:studio) }
    let(:user) { Factory(:user) }
    let(:signed_request) { FacebookAuthenticationFaker.authed_facebook_signed_request('user_id' => user.facebook_user_id) }

    context "with an existing user for the facebook user's signed request" do
      it "should fetch the existing user" do
        get :index, :signed_request => signed_request, :studio_id => studio.id
        assigns(:facebook_user).should == user
      end
    end

    context "when there is no logged facebook user/signed request" do
      it "should return nil" do
        get :index, :studio_id => studio.id
        assigns(:facebook_user).should be_nil
      end
    end

    describe "dev env hax" do
      context "in development environment" do
        before do
          Rails.env.stub!(:development?).and_return(true)
        end

        context "with a fb_user param" do
          it "uses a fake signed request" do
            dev_user = Factory(:user, :facebook_user_id => "dev_user")
            get :index, :fb_user => "dev_user", :studio_id => studio.id
            response.should be_success
            assigns(:facebook_user).should == dev_user
          end
        end

        context "without a fb_user param" do
          it "uses the real signed request" do
            get :index, :signed_request => signed_request, :studio_id => studio.id
            assigns(:facebook_user).should == user
          end
        end
      end
    end
  end
end
