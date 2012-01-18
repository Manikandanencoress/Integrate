Feature: Inviting a Milyoni Admin
  Scenario: Creating an invitation
    Given I am logged in as a milyoni admin
    And I am on the admin studios page
    When I follow "Invitations"
    Then I should be on the admin invitations page
    When I follow "Invite an admin"
    And I invite "ponies@unicorns.us"
    Then I should see "Email Sent"
    And I should see the invitation to "ponies@unicorns.us"

  Scenario: Redeeming an invitation
    Given there is an invitation to "john@franklin.com"
    When I go to the link in the invitation email to "john@franklin.com"
    Then I should see "Milyoni Admin - Sign Up!"
    And the "Email" field should contain "john@franklin.com"
    When I enter my admin login info as "joe@homebody.com/rectangles"
    When I press "Create Account"
    Then I should see "Welcome! joe@homebody.com"

  Scenario: Delete an invitation
    Given I am logged in as a milyoni admin
    And there is an invitation to "john@franklin.com"
    When I go to the admin invitations page
    Then I should see "john@franklin.com"
    When I press "Delete"
    Then I should not see "john@franklin.com"
