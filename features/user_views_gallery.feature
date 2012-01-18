Feature: User can see a list of movies from a studio

  Background:
    Given a studio called "Warner"
    And a studio called "Paramount"
    And an "intense teen dramady" called "The Senior Prom" from "Warner"
    And a "testosterone fueled action film" called "Hard Vengance" from "Warner"
    And a movie called "Paramount Movie" from "Paramount"

  Scenario: Go to a studio's movie list
    Given I'm logged into Facebook as "foo"
    When I go to the "Warner" gallery as "foo"
    Then I should see "The Senior Prom"
    And I should see "Hard Vengance"
    And I should not see "Paramount Movie"
    When I filter genre to "intense teen dramady"
    Then I should see "The Senior Prom"
    And I should not see "Hard Vengance"

  Scenario: User has Active Rentals
    Given a facebook user "Fred Flintstone"
    Given "Fred Flintstone" has an active order for "Hard Vengance"
    When I go to the "Warner" gallery as "Fred Flintstone"
    Then I should see "Hard Vengance" in only the active rentals section

#  Scenario: Go to a movie from a studio's movie list
#    When I go to the "Warner" gallery
#    And I follow "The Senior Prom"
#    Then I should be on the "The Senior Prom" page