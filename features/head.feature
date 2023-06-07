@head
Feature: Head

  As a developer
  In order to add something to the site head
  I want to set it in the configuration

  Background:
    Given I am logged in

  Scenario: Set the head in the configuration
    Given a configuration of:
    """
      ActiveAdmin.application.head = '<meta name="custom_meta" content="custom_value">'.html_safe
    """
    When I am on the dashboard
    Then the site should contain a meta tag with name "custom_meta" and content "custom_value"

  Scenario: Set the head to a proc
    Given a configuration of:
    """
      ActiveAdmin.application.head = proc { '<meta name="custom_meta" content="custom_value">'.html_safe }
    """
    When I am on the dashboard
    Then the site should contain a meta tag with name "custom_meta" and content "custom_value"
