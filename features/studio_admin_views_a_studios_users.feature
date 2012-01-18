Feature: Studio Admin can view the users who have made orders on this studio's movies

  Background: As a logged in admin
    Given I am logged in as a milyoni admin
    And "Barack Obama" from KE has used the site
    And "Bill Clinton" from US has used the site
    And "Ralph Nader" from US has used the site

  Scenario: See a list of users based on orders
    Given a studio with a "warner" player called "Warner Bros"
    Given a studio called "Green Threat Industries"
    And a movie called "Ghostbusters" from "Warner Bros"
    And a movie called "How Stella Got Her Groove Back" from "Warner Bros"
    And a movie called "Carpetbaggers" from "Green Threat Industries"
    And "Bill Clinton" has ordered "Ghostbusters"
    And "Barack Obama" has ordered "Ghostbusters"
    And "Barack Obama" has ordered "Carpetbaggers"
    And "Barack Obama" has ordered "How Stella Got Her Groove Back"
    And "Ralph Nader" has looked at "Ghostbusters" 2 times
    And "Ralph Nader" has ordered "Carpetbaggers"
    When I go to the admin studio page for "Warner Bros"
    And I follow "Users"
    Then I should see the users table:
      | Users        | Country | Orders | Visits |
      | Barack Obama | KE      | 2      | 6      |
      | Bill Clinton | US      | 1      | 3      |
      | Ralph Nader  | US      | 0      | 2      |
    When I filter to only show purchasers
    Then I should see the users table:
      | Users        | Country | Orders | Visits |
      | Barack Obama | KE      | 2      | 6      |
      | Bill Clinton | US      | 1      | 3      |
    When I follow "Barack Obama"
    Then I should see "Ghostbusters"
    Then I should see "How Stella Got Her Groove Back"
    And I should not see "Carpetbaggers"