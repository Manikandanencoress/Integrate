Feature: Admin section authorizations

  Background:
    Given a studio with a "warner" player called "Warner"
    And a studio with a "brightcove" player called "Paramount"

  Scenario: Milyoni Admin can view multiple studios & movies
    Given I am logged in as a milyoni admin
    When I go to the admin movies page for "Warner"
    Then I should see "Warner's Movies"
    When I go to the admin movies page for "Paramount"
    Then I should see "Paramount's Movies"

    When I follow "Logout"
    Then I should be on the login page
    And I should not see "Logout"

  Scenario: Warner Admin can only view Warner movies & reports
    Given I am logged in as a "Warner" admin
    When I go to the admin movies page for "Warner"
    Then I should see "Warner's Movies"
    When I go to the admin movies page for "Paramount"
    Then I should see "Warner's Movies"


  