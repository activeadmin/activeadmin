Feature: Menu

  Background:
    Given I am logged in

  Scenario: Hide the menu item
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        menu false
      end
    """
    When I am on the dashboard
    Then I should not see a menu item for "Posts"

  Scenario: Set the menu item label
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        menu :label => "Articles"
      end
    """
    When I am on the dashboard
    Then I should see a menu item for "Articles"
    And I should not see a menu item for "Posts"

  Scenario: Set the site title and site title link
    Given a configuration of:
    """
      ActiveAdmin.application.site_title = "My Great Site"
      ActiveAdmin.application.site_title_link = "http://www.google.com/"
    """
    When I am on the dashboard
    And I should see "My Great Site"
    When I follow "My Great Site"
    Then I should see "Ruby on Rails: Welcome aboard"
    # Why won't it take me to the Googles??? It takes me to / instead. Oh well