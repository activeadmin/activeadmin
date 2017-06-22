Feature: Favicon

  Configuring a Favicon file

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register Post
      ActiveAdmin.application.favicon = "a/favicon.ico"
    """

  Scenario: Logged out views show Favicon
    Given I am logged out
    When I am on the login page
    Then I should see the favicon "favicon"

  Scenario: Logged in views show Favicon
    Given I am logged in
    When I am on the dashboard
    Then I should see the favicon "favicon"