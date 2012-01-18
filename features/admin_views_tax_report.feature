Feature: Admin views tax report for a movie

  Background: As a logged in admin
    Given I am logged in as a milyoni admin

  Scenario: Viewing the tax report
    Given a movie called "Some Movie" from "Warner Bros"
    And "Some Movie" has these orders:
      | Facebook Order Id | Status  | Facebook User Id | Rented At            | Credits | Tax Collected | Zip Code |
      | 1                 | pending | Ben Franklin     | 03/04/05 12:01pm UTC | 35      | 0.1           | 98111    |
      | 2                 | settled | Ralph Nader      | 04/05/06 2:45pm UTC  | 45      | 0.00          | 98111    |
    Given a movie called "Some Other Movie" from "Warner Bros"
    And "Some Other Movie" has these orders:
      | Facebook Order Id | Status  | Facebook User Id | Rented At            | Credits | Tax Collected | Zip Code |
      | 3                 | pending | Chuck Norris     | 03/04/05 12:01pm UTC | 35      | 0.00          | 01609    |
      | 4                 | settled | Dark Vader       | 04/05/06 2:45pm UTC  | 45      | 0.00          | 01609    |
    When I go to the admin movies page for "Warner Bros"
    And I follow "Tax Report"
    Then I should see "Tax Report"
    And I should see orders table
      | Movie            | Tax Collected | Zip Code | Rented at          | Facebook user | Facebook order | Status  | Total credits |
      | Some Movie       | 0.10          | 98111    | 03/04/05 - 12:01PM | Ben Franklin  | 1              | pending | 35            |
      | Some Movie       | 0.00          | 98111    | 04/05/06 - 02:45PM | Ralph Nader   | 2              | settled | 45            |
      | Some Other Movie | 0.00          | 01609    | 03/04/05 - 12:01PM | Chuck Norris  | 3              | pending | 35            |
      | Some Other Movie | 0.00          | 01609    | 04/05/06 - 02:45PM | Dark Vader    | 4              | settled | 45            |