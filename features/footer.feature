Feature: Site title

  As a developer
  In order to customize the site footer
  I want to set it in the configuration

  Background:
    Given I am logged in

  Scenario: No footer is set in the configuration (default)
    When I am on the dashboard
    And I should see the default footer

  Scenario: Set the footer in the configuration
    Given a configuration of:
    """
      ActiveAdmin.application.footer = "MyApp Revision 123"
    """
    When I am on the dashboard
    And I should see the footer "MyApp Revision 123"

  Scenario: Set the footer to a proc
    Given a configuration of:
    """
      ActiveAdmin.application.footer = proc { "Enjoy MyApp Revision 123, #{controller.current_admin_user.try(:email)}!" }
    """
    When I am on the dashboard
    And I should see the footer "Enjoy MyApp Revision 123, admin@example.com!"
