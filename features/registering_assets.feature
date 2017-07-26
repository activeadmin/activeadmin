Feature: Registering Assets

  Registering CSS and JS files

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    And I am logged in

  Scenario: Viewing default asset files
    When I am on the index page for posts
    Then I should see the css file "active_admin"
    Then I should see the js file "active_admin"
