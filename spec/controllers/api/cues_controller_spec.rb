require 'spec_helper'

describe Api::CuesController do

  describe("#callback") do
    it("returns a commentary clip when the meta content is one") do
      VCR.use_cassette :brightcove_api_url_for_commentary, :record => :new_episodes do
        get :callback, :meta => '~1161807728001~'
        the_kind = assigns(:the_kind)

        #commentaries and clips share the clips model
        the_kind.class.to_s.should == "Clip"
        the_kind.is_commentary.should == true
      end
    end

    it "returns a normal clip when the meta content is a normal one" do
      VCR.use_cassette :brightcove_api_url_for_normal, :record => :new_episodes do
        get :callback, :meta => '[1079164031001]'
        the_kind = assigns(:the_kind)
        the_kind.class.to_s.should == "Clip"
        the_kind.is_commentary.should be_nil
      end
    end

    describe "clip share incremented" do
      it "should change number of shares of a clip" do
        quote = Factory.create(:quote)

        expect {
          get :share_counter,
              :kind => 'quote',
              :id => quote.id,
              :studio_id => Studio.first.id,
              :fb_user => 'foo'
        }.to change { Share.count }.by 1
      end
    end

  end

end

