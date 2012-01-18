Feature: Admin views a studio's report
  Background: As a logged in admin
    Given I am logged in as a milyoni admin

  Scenario: View report of studio's movies
    Given a movie called "Some Movie" from "Warner Bros" with price "10"
    And 2 visits today to "Some Movie"
    And 1 orders today for "Some Movie" at price "2"

    And 3 visits 2 months ago to "Some Movie"
    And 1 orders 2 months ago for "Some Movie" at price "5"

    Given a movie called "Another Movie" from "Warner Bros" with price "20"
    And 5 visits today to "Another Movie"
    And 1 orders today for "Another Movie" at price "3"

    And 10 visits 2 months ago to "Another Movie"
    And 2 orders 2 months ago for "Another Movie" at price "5"

    When I am on the admin studio movies report page for "Warner Bros"

    Then I should see "Movies Report For Warner Bros"
    Then I should see the studio report:
      | Movie         | Day's Users | Day's Buys | Price | Day's Conversion | Day's Revenue | Cum. Users | Cum. Buys | Cum. Conversion | Cum. Revenue |
      | Some Movie    | 2           | 1          | 10    | 50.000%          | 2             | 5          | 2         | 40.000%         | 7            |
      | Another Movie | 5           | 1          | 20    | 20.000%          | 3             | 15         | 3         | 20.000%         | 13           |
    When I filter to 2 months ago
    Then I should see the studio report:
      | Movie         | Day's Users | Day's Buys | Price | Day's Conversion | Day's Revenue | Cum. Users | Cum. Buys | Cum. Conversion | Cum. Revenue |
      | Some Movie    | 3           | 1          | 10    | 33.333%          | 5             | 3          | 1         | 33.333%         | 5            |
      | Another Movie | 10          | 2          | 20    | 20.000%          | 10            | 10         | 2         | 20.000%         | 10           |