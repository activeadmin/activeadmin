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

  Scenario: Add a non-resource menu item
    Given a configuration of:
    """
      ActiveAdmin.application.namespace :admin do |admin|
        admin.build_menu do |menu|
          menu.add :label => "Custom Menu", :url => :admin_dashboard_path
        end
      end
    """
    When I am on the dashboard
    Then I should see a menu item for "Custom Menu"
    When I follow "Custom Menu"
    Then I should be on the admin dashboard page

  Scenario: Adding a resource as a sub menu item
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        menu :parent => 'User'
      end
    """
    When I am on the dashboard
    Then I should see a menu item for "Users"
    When I follow "Users"
    Then the "Users" tab should be selected
    And I should see a nested menu item for "Posts"
