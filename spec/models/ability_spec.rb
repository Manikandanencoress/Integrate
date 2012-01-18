require 'spec_helper'

describe Ability do
    let(:studio_admin) {Factory(:studio_admin)}
    let(:studio_ability) {Ability.new(studio_admin)}
    let(:milyoni_admin) {Factory(:admin)}
    let(:milyoni_ability) {Ability.new(milyoni_admin)}

    it "doesn't allow a studio admin to access another studio" do
      studio = Factory(:studio)
      studio_ability.can?(:read, studio).should be_false
      milyoni_ability.can?(:read, studio).should be_true
    end

    it "doesn't let an admin index studios" do
      studio_ability.can?(:index, Studio).should be_false
      milyoni_ability.can?(:index, Studio).should be_true
    end
end