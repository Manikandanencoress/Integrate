require 'spec_helper'

describe Admin::StudiosController do
  render_views
  it_behaves_like "an authorization-required studio admin controller"

  describe "authorizations" do
    let(:studio_admin) { Factory(:studio_admin) }
    before do
    end

    it "should redirect" do
      sign_in(studio_admin)
      get :index
      response.should redirect_to(admin_studio_path(studio_admin.studio))
    end

  end

  describe "GET new" do
    let(:request_to_make) { lambda { get :new } }
    it_behaves_like "an admin authenticated action"

    describe "role-based authorizations" do
      let(:admin_studio) { Factory :studio }
      let(:studio_admin) { Factory :admin, :studio => admin_studio }

      describe "as a milyoni admin" do
        it "renders correctly" do
          sign_in Factory(:admin)
          request_to_make.call
          response.code.should == "200"
        end
      end
      context "as a studio admin" do
        it "should redirect to admin's studio page" do
          sign_in studio_admin
          request_to_make.call
          response.should redirect_to(admin_studio_path(studio_admin.studio))
        end
      end
    end
  end

  describe "GET index" do
    let(:request_to_make) { lambda { get :index } }
    it_behaves_like "an admin authenticated action"

    describe "role-based authorizations" do
      let(:admin_studio) { Factory :studio }

      let(:studio_admin) { Factory :admin, :studio => admin_studio }

      describe "as a milyoni admin" do
        it "renders correctly" do
          sign_in Factory(:admin)
          request_to_make.call
          response.code.should == "200"
        end
      end
      context "as a studio admin" do
        it "should redirect to admin's studio page" do
          sign_in studio_admin
          request_to_make.call
          response.should redirect_to(admin_studio_path(studio_admin.studio))
        end
      end
    end

    describe "rendering" do
      before do
        sign_in Factory(:admin)
      end

      it "assigns all the studio's movies as @movies" do
        studio1 = Factory :studio
        studio2 = Factory :studio
        get :index
        assigns(:studios).should include(studio1)
        assigns(:studios).should include(studio2)
      end
    end
  end

  describe "GET edit" do
    before do
      @studio = Factory :studio
      @request_params = {:id => @studio.id}
    end
    let(:request_to_make) { lambda { get :edit, @request_params } }
    it_behaves_like "an admin authenticated action"

    describe "role-based authorizations" do
      context "as a milyoni admin" do
        before do
          @milyoni_admin = Factory(:admin)
          sign_in @milyoni_admin
        end
        it "renders correctly" do
          request_to_make.call
          response.code.should == "200"
          assigns(:studio).should == @studio
        end
      end

      context "as a studio admin" do
        before do
          @studio_admin = Factory :admin, :studio => @studio
          sign_in @studio_admin
        end

        it "with the admin's studio should render the page" do
          request_to_make.call
          response.code.should == "200"
        end

        it "with another studio should redirect to admin's studio page" do
          @request_params[:id] = Factory(:studio).id
          request_to_make.call
          response.should redirect_to(admin_studio_path(@studio))
        end
      end
    end
  end

  describe "PUT update" do
    before do
      @studio = Factory :studio
      @request_params = {:id => @studio.id, :studio => Factory.build(:studio).attributes}
    end

    let(:request_to_make) { lambda { put :update, @request_params } }

    it_behaves_like "an admin authenticated action"

    describe "role-based authorizations" do
      context "as a milyoni admin" do
        before do
          @milyoni_admin = Factory(:admin)
          sign_in @milyoni_admin
        end

        it "renders correctly" do
          request_to_make.call
          response.code.should == "302"
          assigns(:studio).should == @studio
        end
      end

      context "as a studio admin" do
        before do
          @studio_admin = Factory :studio_admin, :studio => @studio
          sign_in @studio_admin
        end

        it "with the admin's studio should update the studio" do
          @request_params[:studio][:name] = "ponyland"
          request_to_make.call
          Studio.find(@studio.id).name.should == "ponyland"
          response.should redirect_to(admin_studio_path(@studio))
        end

        context "when trying to set the comment_stream_enabled" do
          before do
            @request_params[:studio][:comment_stream_enabled] = true
          end

          it "is forbidden" do
            request_to_make.call
            response.status.should == 403
          end

          it "doesn't update the model" do

            lambda do
              request_to_make.call
            end.should_not change{Studio.find(@studio.id).comment_stream_enabled?}
          end

        end



        it "with another studio should redirect to admin's studio page & not make any updates" do
          another_studio = Factory(:studio, :name => "some other studio")
          @request_params[:id] = another_studio.id
          @request_params[:studio][:name] = "not authorized to make this change"
          request_to_make.call
          another_studio.reload.name.should == "some other studio"
          response.should redirect_to(admin_studio_path(@studio))
        end
      end
    end

  end

  describe "GET show" do
    let(:studio) { Factory :studio }
    let(:request_to_make) { lambda { get :show, :id => studio.id } }

    context "When not logged in" do
      it "should make you log in" do
        request_to_make.call
        response.should redirect_to(new_admin_session_path)
      end
    end

    context "When logged in" do
      it "as a milyoni admin redirects to the movies index" do
        sign_in Factory(:admin)
        request_to_make.call
        response.should redirect_to(admin_info_studios_path)
      end

      it "as a studio admin redirects to the admin's studio's path" do
        admin_studio = Factory :studio
        studio_admin = Factory :admin, :studio => admin_studio
        sign_in studio_admin
        request_to_make.call
        response.should redirect_to(admin_studio_path(admin_studio))
      end
    end
  end

  describe "GET studioinfo" do
    let(:request_to_make) do
      lambda do
        admin_studioinfo_path
      end
    end 
    
    describe "role-based authorizations" do
      let(:admin_studio) { Factory :studio }
      let(:studio_admin) { Factory :admin, :studio => admin_studio }

      describe "as a milyoni admin" do
        it "renders correctly" do
          sign_in Factory(:admin)
          request_to_make.call
          response.code.should == "200"
        end
      end
      
      context "as a studio admin" do
        it "should redirect to admin's studio page" do
          sign_in studio_admin
          request_to_make.call
          response.should be_success
        end
      end
    end
    
  end
  
  describe "GET studiolist" do
    let(:studio) { Factory :studio }    
    let(:request_to_make) do
      lambda do
        admin_studiolist_path
      end
    end 
    describe "as a milyoni admin" do
      it "renders correctly" do
        sign_in Factory(:admin)
        request_to_make.call
        response.code.should == "200"
      end
    end
  end
  
end
