require "spec_helper"

describe Admin::RegistrationsController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:admin]
  end

  describe "GET #new" do
    describe "without an invitation" do
      it "should redirect to google" do
        get :new, :token => "adsfasf"
        response.should redirect_to "http://google.com"
      end
    end

    describe "with an invitation" do
      before do
        @invitation = Factory(:invitation)
      end

      it "Generates a new admin from the invitation" do
        get :new, :token => @invitation.token
        assigns(:admin).should be_present
        assigns(:admin).email.should == @invitation.email
        assigns(:admin).invitation.token.should == @invitation.token
      end
    end
  end

  describe "POST #create" do
    describe "without a valid invitation" do
      context "a blank invitation" do
        it "should redirect to google" do
          post :create
          response.should redirect_to "http://google.com"
        end
      end
      context "a nonexistent invitation" do
        it "should redirect to google" do
          post :create, :token => "asdfasdfa"
          response.should redirect_to "http://google.com"
        end
      end
      context "a used up invitation" do
        it "should redirect to google" do
          invitation = Factory(:invitation)
          admin = Factory(:admin, :invitation => invitation)
          post :create, :token => invitation.token
          response.should redirect_to "http://google.com"
        end
      end
    end

    describe "with an invitation" do
      before do
        @invitation = Factory(:invitation)
      end
      it "should create a user when valid params" do
        post :create,
             :token => @invitation.token,
             :admin => {:email => "joe@yucyucyuc.com", :password => "starfish", :password_confirmation => "starfish"}

        Admin.last.invitation.should == @invitation
        response.should redirect_to admin_studios_path
      end

      it "should render new when params suck" do
        post :create,
             :token => @invitation.token,
             :admin => {:email => 'not an email address', :password => "starfish", :password_confirmation => "starfish"}
        assigns(:admin).should be_new_record
        response.should render_template(:new)
      end
    end
  end
end