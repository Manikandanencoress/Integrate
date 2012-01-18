Feature: Admin edits movies in the admin panel
  Background: As a logged in admin
    Given I am logged in as a milyoni admin

  Scenario: Create a new movie for Warner
    And a studio with a "warner" player called "Warner Bros"
    When I am on the admin movies page for "Warner Bros"
    When I follow "New Movie"
    Then I should see "Add a Movie"
    And I should see "for Warner Bros"
    And I should not see "Brightcove movie"
    And I press "Save & Continue"
    Then I should see "can't be blank"
    When I fill in valid movie info for a Warner movie
    And I fill in "Title" with "New Movie Name"
    And I select "Sci-Fi" from "Genre"
    And I press "Save & Continue"
    Then I should see "Movie was successfully created"
    And I should see "New Movie Name"
    And I should see "Sci-Fi"
    And I should see "Facebook Link"
    And I should see the admin movie preview

    When I follow "Look & Feel"
    When choose all the images to upload
    And I press "Update Skin"
    Then I should see all of the image previews

  Scenario: Create a new movie for Brightcove Studio
    Given a studio with a "brightcove" player called "Miramax"
    When I am on the admin movies page for "Miramax"
    When I follow "New Movie"
    Then I should see "Add a Movie"
    And I should see "for Miramax"
    And I should not see "Cdn path"
    And I should not see "Video file path"
    And I press "Save & Continue"
    Then I should see "can't be blank"
    When I fill in valid movie info for a Brightcove movie
    And I fill in "Title" with "Pulp Fiction"
    And I select "Sci-Fi" from "Genre"
    And I press "Save & Continue"
    Then I should see "Movie was successfully created"
    And I should see "Pulp Fiction"
    And I should see the admin movie preview

  @the_notebook_facebook_url
  Scenario: Edit an existing movie
    Given a movie called "Some Movie" from "Warner Bros"
    When I am on the admin movies page for "Warner Bros"
    Then I follow "Some Movie"
    And I follow "Edit Info"
    And I fill in "Title" with "New Movie Name"
    And I fill in "Facebook fan page url" with "http://www.facebook.com/TheNotebookMovie"
    And I press "Save & Continue"
    Then I should see "Movie was successfully updated"
    And I should see "New Movie Name"
    And I should see "Facebook fan page id: 204558349574109"
