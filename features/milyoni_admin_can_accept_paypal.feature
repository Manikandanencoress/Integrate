Feature: Studio admin can accept Paypal

  Background:
    Given a studio called "Crackers International" with paypal enabled
    Given a movie called "An Affair with Mrs Santa" from "Crackers International"

  @javascript @option_with_paypal_on
  Scenario: A Studio admin decides to accept Paypal as a payment method.

    Given I'm logged into Facebook as "Sugar Daddy"
    When I go to the "An Affair with Mrs Santa" page
    And I've gone to the "An Affair with Mrs Santa" watch page and have accepted the FB app
    Then I should see "An Affair with Mrs Santa"