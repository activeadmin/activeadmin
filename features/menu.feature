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

  Scenario: Set the parent menu item as a string
    Given a configuration of:
    """
      ActiveAdmin.register_page "Child" do
        menu :parent => "Parent"
      end
    """
    When I am on the dashboard
    Then I should see a menu item for "Parent"
    And I should see "Child" as a child menu of "Parent"
    And I should not see a menu item for "Child"

  Scenario: Set the parent menu item as a hash of options
    Given a configuration of:
    """
      ActiveAdmin.register_page "Child" do
        menu :parent => {:priority => 0, :label => "Parent",
                         :url => 'wee'}
      end
    """
    When I am on the dashboard
    Then I should see "Dashboard" after "Parent"
    And "Parent" should link to "wee"
