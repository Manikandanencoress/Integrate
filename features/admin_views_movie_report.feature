Feature: Admin views movie report
  Background: As a logged in admin
    Given I am logged in as a milyoni admin

  Scenario: Admin views movie report
    Given a movie called "Some Movie" from "Warner Bros"
    And 10 visits today to "Some Movie"
    And 15 visits 1 month ago to "Some Movie"
    And 5 visits today to the "Some Movie" watch page
    And 7 visits 1 month ago to the "Some Movie" watch page
    And 2 orders today for "Some Movie" at price "4"
    And 2 orders 1 month ago for "Some Movie" at price "10"
    When I am on the admin movie report page for "Some Movie"
    Then I should see "Report for Some Movie"
    And I should see the report:
      | metric                        | value   |
      | Lifetime Orders               | 4       |
      | Lifetime Purchase Page Visits | 25      |
      | Lifetime Watch Page Visits    | 12      |
      | Lifetime Revenue              | 28      |
      | Lifetime Conversion Rate      | 16.000% |
      | Today's Orders                | 2       |
      | Today's Purchase Page Visits  | 10      |
      | Today's Watch Page Visits     | 5       |
      | Today's Revenue               | 8       |
      | Today's Conversion Rate       | 20.000% |