class GroupDiscount < ActiveRecord::Base
  belongs_to :order

  def validate_discount_key
    valid, expired, viewing_party_complete = true, true, true

      if expired?
        valid, expired, viewing_party_complete = false, true, false
      elsif viewing_party_complete?
        valid, expired, viewing_party_complete = false, false, true
      else
        valid, expired, viewing_party_complete = true, false, false
      end

    [valid, expired, viewing_party_complete]
  end


  def expired?
    created_at < 7.days.ago ? true : false
  end

  def viewing_party_complete?
    count = RedeemDiscount.find_all_by_group_discount_id(id).count
    count > 5 ? true : false
  end

end
