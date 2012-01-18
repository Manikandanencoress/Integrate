Given /^the following orders exist for "(.*)":$/ do |movie_title, table|
  movie = Movie.find_by_title(movie_title)
  table.hashes.each do |hash|
    time = Time.strptime(hash['Rented At'], '%m/%d/%y %H:%M%p %Z')
    order = Factory :order,
            :facebook_order_id => hash['Facebook Order Id'],
            :user => User.find_by_name(hash['Facebook User Id']) || Factory(:user, :name => hash['Facebook User Id']),
            :status => hash['Status'],
            :rented_at => time,
            :movie => movie,
            :total_credits => hash['Credits']
  end
end

Given /^"([^"]*)" has these orders:$/ do |movie_title, table|
  movie = Movie.find_by_title(movie_title)
  table.hashes.each do |hash|
    time = Time.strptime(hash['Rented At'], '%m/%d/%y %H:%M%p %Z')
    order = Factory :order,
            :facebook_order_id => hash['Facebook Order Id'],
            :user => User.find_by_name(hash['Facebook User Id']) || Factory(:user, :name => hash['Facebook User Id']),
            :status => hash['Status'],
            :rented_at => time,
            :movie => movie,
            :total_credits => hash['Credits'],
            :zip_code => hash['Zip Code'],
            :tax_collected => hash['Tax Collected']
  end
end


And /^I should see orders table$/ do |expected_table|
  actual_table = table(tableish('table tr', 'td, th'))
  expected_table.diff!(actual_table)
end

And /^(\d+) orders today for "([^"]*)" at price "(\d+)"$/ do |order_count, movie_title, price|
  movie = Movie.find_by_title(movie_title)
  raise "No movie found" unless movie.present?
  
  order_count.to_i.times do |i|
    order = Factory :settled_order, :movie => movie, :total_credits => price.to_i, :rented_at => Date.today.beginning_of_day + 1
  end
end


And /^(\d+) orders (\d+) month(?:|s) ago for "([^"]*)" at price "(\d+)"$/ do |order_count, months_ago, movie_title, price|
  movie = Movie.find_by_title(movie_title)
  raise "No movie found" unless movie.present?

  order_count.to_i.times do |i|
    rented_at = noon_months_ago_utc(months_ago)
    Factory :settled_order, :movie => movie,
            :total_credits => price.to_i, :rented_at => rented_at
  end
end

Given /^There is a disputed order for "([^\"]*)"$/ do |title|
  movie = Movie.find_by_title(title)  || Factory(:movie, :title => title)
  Factory(:order,
          :movie => movie,
          :status => 'disputed',
          :rented_at => 500.years.ago) # before obama was president
end

Given /^facebook is stubbed to allow refunds$/ do
  FbGraph::Application.stub(:new).and_return(double('mock_facebook', :get_access_token => 'foo'))
  FbGraph::Order.stub!(:new).and_return(double('mock_fb_order', :refunded! => true))
end

When /^"([^\"]*)" has ordered "([^\"]*)"$/ do |facebook_user_name, title|
  movie = Movie.find_by_title!(title)
  fb_user = User.find_by_name(facebook_user_name)
  Order.create!(:user => fb_user, :movie => movie).settle!
  3.times { movie.page_visits.for_purchase_page.create! :user => fb_user}
end

And /^I get a CSV file$/ do
  page.response_headers['Content-Type'].should =~ /text\/csv/
end
