Feature: Admin views orders for a movie

  Background: As a logged in admin
    Given I am logged in as a milyoni admin

  Scenario: Viewing some orders
    Given a movie called "Some Movie"
    And the following orders exist for "Some Movie":
      | Facebook Order Id | Status  | Facebook User Id | Rented At            | Credits |
      | 1                 | pending | Ben Franklin     | 03/04/05 12:01pm UTC | 35      |
      | 2                 | settled | Ralph Nader      | 04/05/06 2:45pm UTC  | 45      |
    When I go to the admin orders page for "Some Movie"
    Then I should see "Orders for Some Movie"
    And I should see orders table
      | Rented at          | Facebook user | Facebook order | Status  | Total credits |
      | 03/04/05 - 12:01PM | Ben Franklin  | 1              | pending | 35            |
      | 04/05/06 - 02:45PM | Ralph Nader   | 2              | settled | 45            |
    Then I follow "Export CSV"
    And I get a CSV file

  Scenario: Refunding a transaction
    Given There is a disputed order for "Raiders of the Lost Ark"
    When I go to the admin orders page for "Raiders of the Lost Ark"
    Then I should see a "Refund" submit button
    Given facebook is stubbed to allow refunds
    When I press "Refund"
    Then I should see "refunded"
    Then I should not see a "Refund" submit button