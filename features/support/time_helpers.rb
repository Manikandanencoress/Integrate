def noon_months_ago_utc(months)
  to_noon = {:hour => 12, :min => 0, :sec => 0}
  months.to_i.months.ago.change(to_noon).utc
end