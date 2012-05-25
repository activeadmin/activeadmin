Feature: Namespace root

  As a developer
  In order to customize the welcome page
  I want to set it in the configuration

  Scenario: Default root is the Dashboard
    Given I am logged in
    Then I should be on the dashboard

  Scenario: Set root to "posts#index"
    Given a configuration of:
    """
      ActiveAdmin.application.root = 'stores#index'
    """
    Given I am logged in
    Then I should see the page title "Bookstores"
