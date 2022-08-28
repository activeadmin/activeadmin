@site_title
Feature: Site title

  As a developer
  In order to customize the site title
  I want to set it in the configuration

  Background:
    Given I am logged in

  Scenario: Set the site title and site title link
    Given a configuration of:
    """
      ActiveAdmin.application.site_title = "My Great Site"
      ActiveAdmin.application.site_title_link = "/admin"
      ActiveAdmin.application.site_title_image = ""
    """
    When I am on the dashboard
    And I should see the site title "My Great Site"
    And I follow "My Great Site"
    Then I should see the site title "My Great Site"

  Scenario: Set the site title image
    Given a configuration of:
    """
      ActiveAdmin.application.site_title_image = "logo.png"
    """
    When I am on the dashboard
    And I should not see the site title "My Great Site"
    And I should see the site title image "logo.png"

  Scenario: Set the site title image with link
    Given a configuration of:
    """
      ActiveAdmin.application.site_title_link = "http://www.google.com"
      ActiveAdmin.application.site_title_image = "logo.png"
    """
    When I am on the dashboard
    And I should see the site title image "logo.png"
    And I should see the site title image linked to "http://www.google.com"

  Scenario: Set the site title to a proc
    Given a configuration of:
    """
      ActiveAdmin.application.site_title = proc { "Hello #{controller.current_admin_user.try(:email) || 'you!'}" }
      ActiveAdmin.application.site_title_image = ""
    """
    When I am on the dashboard
    And I should see the site title "Hello admin@example.com"
