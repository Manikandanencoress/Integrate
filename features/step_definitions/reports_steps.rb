And /^I should see the report:$/ do |report_metrics|
  report_metrics.hashes.each do |metric_hash|
    page.should have_content("#{metric_hash[:metric]}: #{metric_hash[:value]}")
  end
end
