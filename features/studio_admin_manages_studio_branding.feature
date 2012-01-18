Feature: Studio Admin manages studio branding
  Background: As a logged in Warner Bros admin
    Given a studio called "Warner Bros"
    And I am logged in as a "Warner Bros" admin

  Scenario: View branding for a studio
    And I am on the admin studio page for "Warner Bros"
    When I follow "Branding"
    Then I should be on the edit admin studio branding page for "Warner Bros"
    When I attach a brand image to the branding form
    And I press "Update Branding"
    When I go to the "Warner Bros" gallery
    Then I should see the "Warner Bros" logo
