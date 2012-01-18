Feature: Milyoni admin can change a studio's movies' type of comment

  Background:
    Given a studio called "Cool Studio"
    Given a movie called "Cool Spot" from "Cool Studio"

  Scenario: Milyoni Admin can change comment type
    Given I'm logged into Facebook as "Your Mother"
    And "Your Mother" has an active order for "Cool Spot"

    When I go to the "Cool Spot" page
    Then I should see the facebook comments
    But I should not see the comment stream

    Given I am logged in as a milyoni admin
    And I am on the admin movies page for "Cool Studio"
    When I follow "Studio Edit"
    When I check "Enable Comment Stream"
    And I press "Update Studio"

    When I go to the "Cool Spot" page
    Then I should see the comment stream
    But I should not see the facebook comments

  Scenario: Studio admin can not change comment type
    Given I am logged in as a "Cool Studio" admin
    And I am on the admin movies page for "Cool Studio"
    When I follow "Studio Edit"
    Then I should not see "Enable Comment Stream"