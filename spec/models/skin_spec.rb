require 'spec_helper'

describe Skin do
  it "should belong to movie" do
    should respond_to(:movie)
    Skin.reflect_on_association(:movie).macro.should == :belongs_to
  end

  %w(
    watch_background
    purchase_background
    splash_image
    tax_popup_logo
    tax_popup_icon
    player_background
    facebook_dialog_icon
  ).each do |attachment|
    it { should have_attached_file(attachment.to_sym) }
  end

  describe "#complete?" do
    it "should not be complete if all images aren't set" do
      skin = Factory(:skin)
      skin.should be_complete
      skin.facebook_dialog_icon = nil
      skin.save
      skin.should_not be_complete
    end
  end
end