Feature: User rents & watches a movie
  As a viewer named "Barack Obama"
  I want to rent and watches a movie

  Scenario: Go to the splash page
    Given a movie called "Some Movie Name"
    When I am on the "Some Movie Name" page
    Then I should see the splash page for "Some Movie Name"

  @javascript @taxes_for_98111

  Scenario: Go to the watch page for Warner and buy credits and see tax interface
    Given a movie called "Some Movie Name" from "Warner"
    When I've gone to the "Some Movie Name" watch page and have accepted the FB app
    Then I should see "Some Movie Name"
    Then I should see "48"
    Then I should see "HOUR"
    When I follow "Watch Now"
    Then I should see "Please Enter Your Zip Code"
    And I fill in "Zip Code" with "98111"
    And I press "Go"
    Then I should see "Price: 30.14 Credits"
    Then I should see "Tax: 2.86 Credits"
    Then I should see "Total: 33.00 Credits"

  @javascript @zero_price_movie

  Scenario: Go to the watch page for Warner and buy credits and see tax interface
    Given a movie called "Some Movie Name" which has a price of zero from "Warner"
    When I've gone to the "Some Movie Name" watch page and have accepted the FB app
    Then I should see "Some Movie Name"
    When I follow "Watch Now"
    Then I should not see "Please Enter Your Zip Code"


  @javascript @taxes_for_98111
  Scenario: Go to the watch page for non-Warner and buy credits and don't see tax interface
    Given a movie called "Some Movie Name" from "Big Time"
    When I've gone to the "Some Movie Name" watch page and have accepted the FB app
    Then I should see "Some Movie Name"
    When I follow "Watch Now"
    Then I should not see "Please Enter Your Zip Code"


  @javascript @group_discount_initiator
  Scenario: Initial Renter comes to the watch page for non-Warner and see the group buy interface
    Given a movie called "The Clown" from "Big Time" with group discount
    Given I'm logged into Facebook as "group_discount_initiator"
    When I've gone to the "The Clown" watch page and have accepted the FB app
    Then I should see "The Clown"
    When I follow "Watch Now"
    And I should see "Please disable pop-up blockers to ensure the delivery of your Share With Friends coupon after purchase."


  @javascript @groups_discount_redeemer
  Scenario: Friend clicks on discount link and gets a discount
    Given a movie called "The Clown" from "Big Time" with group discount
    Given I'm logged into Facebook as "groups_discount_redeemer"
    When I've gone to the "The Clown" watch page and have accepted the FB app

    When I've gone to the "The Clown" watch page with an invalid discount key and have accepted the FB app
    Then I should see "The Clown"
    When I follow "Watch Now"
    And I should see "Please disable pop-up blockers to ensure the delivery of your Share With Friends coupon after purchase."

    When I've gone to the "The Clown" watch page with a valid discount key and have accepted the FB app
    Then I should see "The Clown"
    When I follow "Watch Now"
    And I should not see "Please disable pop-up blockers to ensure the delivery of your Share With Friends coupon after purchase."

