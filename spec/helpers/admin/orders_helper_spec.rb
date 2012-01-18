require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the Admin::OrdersHelper. For example:
#
# describe Admin::OrdersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Admin::OrdersHelper do
  describe "refund_button_for_order" do
    context "order :status => 'disputed'" do
      it "should show a button that refunds the order" do
        order = Factory(:order, :status => 'disputed')
        text = helper.refund_button_for_order(order)
        html = Nokogiri::HTML(text)
        button = html.css("input[type='submit']")
        button.should be_present
        button.attribute('data-confirm').should be_present
      end
    end

    context "order :status != 'disputed'" do
      it "should not show anything" do
        order = Factory(:order, :status => 'settled')
        text = helper.refund_button_for_order(order)
        text.should be_blank
      end
    end
  end
end
