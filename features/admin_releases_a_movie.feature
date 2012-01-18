Feature: Studio admin releasing a movie

  Scenario: Don't allow admin to release incomplete movie
    Given I am logged in as a milyoni admin
    And a movie called "Scary Movie" from "Warner Bros" with an incomplete skin
    When I am on the admin movies page for "Warner Bros"
    And I follow "Scary Movie"
    And I follow "Edit Info"
    And I check "Released"
    And I press "Save & Continue"
    Then I should see "Movie must be complete to be released."