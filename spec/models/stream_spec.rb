require 'spec_helper'

describe Stream do
  describe "associations" do
    it "should belongs_to :movie" do
      Stream.reflect_on_association(:movie).macro.should == :belongs_to
    end
  end

	describe "validations" do
	  before do
	    @stream = Stream.new
	    @stream.valid?
	  end	
		%w{ url
        width
        height
        bitrate
    }.each do |i|
      it "validates presence of #{i}" do
        @stream.should have(1).error_on(i.to_sym)
      end
		end
	end
end
