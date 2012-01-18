require 'spec_helper'

describe PageVisit do
  describe ".from_today" do
    let(:utc_christmas) { Time.utc(2010, 12, 25, 12) }
    it "returns visits created after UTC midnight today" do
      Timecop.freeze(utc_christmas)
      from_today = PageVisit.create! :created_at => Time.now.utc
      from_yesterday = PageVisit.create! :created_at => Time.utc(2010, 12, 24, 23, 59)
      PageVisit.from_today.should include(from_today)
      PageVisit.from_today.should_not include(from_yesterday)
    end
  end
end
