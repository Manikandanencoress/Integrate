Feature: Studio Admin Invites

  Background:
    Given a studio with a "warner" player called "Warner"

  Scenario: Studio admin invites another studio admin
    Given I am logged in as a "Warner" admin
    And I am on the admin studio page for "Warner"
    When I follow "View Admins"
    When I follow "Invite a Warner Admin"
    When I invite "rectangles@brokenstarfishes.org"
    And I should see the invitation to "rectangles@brokenstarfishes.org"

  Scenario: Redeeming an invitation
    Given there is a studio invitation to "john@franklin.com" for "Warner"
    When I go to the link in the invitation email to "john@franklin.com"
    Then I should see "Warner Admin - Sign Up!"
    And the "Email" field should contain "john@franklin.com"
    When I enter my admin login info as "joe@homebody.com/rectangles"
    When I press "Create Account"
    Then I should see "Welcome! joe@homebody.com"
    Then "joe@homebody.com" should be a "Warner" admin

  Scenario: Delete an invitation
    Given I am logged in as a "Warner" admin
    And there is a studio invitation to "john@franklin.com" for "Warner"
    And I am on the admin studio page for "Warner"
    When I follow "View Admins"
    When I follow "Pending Invitations"
    Then I should see "john@franklin.com"
    When I press "Delete"
    Then I should not see "john@franklin.com"