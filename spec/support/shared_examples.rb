shared_examples_for "an admin authenticated action" do
  context "When we are not logged in" do
    it "should redirect to the admin sign-in page" do
      request_to_make.call
      response.should redirect_to(new_admin_session_path)
    end
  end

  context "We are logged in as an admin" do
    it "should return a successful request" do
      sign_in Factory(:admin)
      request_to_make.call
      expected_response_code = request.get? ? "200" : "302"
      response.code.should == expected_response_code
    end
  end
end

shared_examples_for "an authorization-required studio admin controller" do
  describe "authentication/authorization for studio admins" do
    let(:other_studio) { Factory(:studio) }
    let(:studio_admin) { Factory(:studio_admin) }

    before do
      sign_in studio_admin
      request_params = {:studio_id => other_studio.id}.merge(@auth_params || {})
      action = controller.respond_to?(:index) ? :index : :show
      get action, request_params
    end

    it "a studio authorized admin controller" do
      response.should redirect_to(admin_studio_path(studio_admin.studio))
    end

    it "authenticates the admin" do
      controller.current_admin.should == studio_admin
    end
  end
end

shared_examples_for "an object that's tagged with genre" do
  describe "genres" do
    it "should be a list of the genres it's tagged with" do
      genred_object.genre_list="zany romantic comedies, madcap bromances, intense teen dramadies"
      genred_object.save

      romantic_comedies = ActsAsTaggableOn::Tag.find_by_name("zany romantic comedies")
      bromance =  ActsAsTaggableOn::Tag.find_by_name("madcap bromances")
      teen_dramadies =  ActsAsTaggableOn::Tag.find_by_name("intense teen dramadies")

      genred_object.genres.should =~ [romantic_comedies, bromance, teen_dramadies]
    end
  end
end