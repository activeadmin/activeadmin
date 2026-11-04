@javascript_modules
Feature: JavaScript modules

  As a developer
  In order to add JavaScript to every Active Admin page
  I want to register import map modules in the configuration

  Background:
    Given I am logged in

  Scenario: No modules registered
    When I am on the dashboard
    Then the page should import "active_admin"

  Scenario: Import registered modules after the entry point
    Given a configuration of:
    """
      ActiveAdmin.application.javascript_modules = ["my_plugin/index", "other_plugin"]
    """
    When I am on the dashboard
    Then the page should import "active_admin" followed by "my_plugin/index, other_plugin"
