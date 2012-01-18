Feature: Admin edits studio info

  Background: As a logged in admin
    Given I am logged in as a milyoni admin

  Scenario: Admin creates a new studio
    Given I am on the admin studios page
    When I follow "New Studio"
    Then I should not see "Brightcove ID"
    And I should not see "Brightcove key"
    When I fill in valid studio info
    And I press "Create Studio"
    Then I should see "Studio was successfully created."

  Scenario: Edit a Warner studio's attributes
    Given a studio with a "warner" player called "Warner"
    And I am on the admin studios page
    When I follow "edit info"
    Then I should not see "Brightcove ID"
    And I should not see "Brightcove key"
    When I fill in valid studio info
    And I press "Update Studio"
    Then I should see "Studio was successfully updated."

  Scenario: Edit a non-Warner studio's attributes
    Given a studio with a "brightcove" player called "Brightcove Studio"
    And I am on the admin studios page
    When I follow "edit info"
    Then I should see "Brightcove ID"
    And I should see "Brightcove key"
    When I fill in valid studio info for a Brightcove studio
    And I press "Update Studio"
    Then I should see "Studio was successfully updated."

  Scenario: Updating a studio's gallery
    Given a studio with a "brightcove" player called "Brightcove Studio"
    And I am on the admin studios page
    When I follow "edit info"
    When I fill in "Copyright notice" with
    """
    &copy; {{name}} 2000. All rights reserved
    """
    And I press "Update Studio"
    When I go to the "Brightcove Studio" gallery
    And I should see the html
    """
    &#169; Brightcove Studio 2000. All rights reserved
    """

  Scenario: Making a studio's genre remain ordered as entered
    Given a studio with a "brightcove" player called "Brightcove Studio"
    And I am on the admin studios page
    When I follow "edit info"
    When I fill in "Genre list (comma separated)" with
    """
    Horror, Comedy, Action, Crime
    """
    And I press "Update Studio"
    When I go to the admin studios page
    And I follow "edit info"
    Then the "Genre list (comma separated)" field should contain "Action, Comedy, Crime, Horror"
    When I am on the admin movies page for "Brightcove Studio"
    Then I should not see "Episodic"

#  Scenario: Enabling Episodic Series for a Studio
#    Given a studio with a "milyoni" player called "Turner Studio"
#    And I am on the admin studios page
#    When I follow "edit info"
#    When I check "Enable Serialized Content"
#    And I press "Update Studio"
#    When I go to the admin studios page
#    And I follow "edit info"
#    Then the "Enable Serialized Content" checkbox should be checked
#    When I am on the admin movies page for "Turner Studio"
#    Then I should see "Episodic"

  @the_notebook_facebook_url_again
  Scenario: Edit a studio's viewing details template for movie pages
    Given a studio with a "warner" player called "Warner"
    And a movie called "Some Movie" from "Warner" with the attributes:
      | facebook_fan_page_url                |
      | http://facebook.com/TheNotebookMovie |
    Given I am on the admin studios page
    When I follow "edit info"
    When I fill in "Viewing details" with
    """
    After purchasing this license, you may watch {{title}}
    as many times as you wish within a 48 hour period. If you
    exit Facebook, simply return to the official
    [{{title}}]({{facebook_fan_page_url}})
    and select the WATCH tab. Alternatively, you can select
    {{title}} application that appears on the left side of
    your Facebook profile page to re-open the video player window.
    Your license to watch {{title}} is not transferable.
    """
    And I press "Update Studio"
    And I've gone to the "Some Movie" watch page and have accepted the FB app
    Then I should see the html
    """
    After purchasing this license, you may watch Some Movie
    as many times as you wish within a 48 hour period. If you
    exit Facebook, simply return to the official
    <a href="http://facebook.com/TheNotebookMovie" target="_top">Some Movie</a>
    and select the WATCH tab. Alternatively, you can select
    Some Movie application that appears on the left side of
    your Facebook profile page to re-open the video player window.
    Your license to watch Some Movie is not transferable.
    """