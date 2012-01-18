module Admin::OrdersHelper

  def refund_button_for_order(order)
    if order.status == 'disputed'
      button_to("Refund", admin_order_path(order, :order => {:status => :refund}), :method => :put, :confirm => "Are you sure you want to refund this?")
    end
  end
end
