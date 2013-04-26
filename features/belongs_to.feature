Feature: Belongs To

  A resource belongs to another resource

  Background:
    Given I am logged in
    And a post with the title "Hello World" written by "John Doe" exists
    And a post with the title "Hello World" written by "Jane Doe" exists

  Scenario: Viewing the child resource index page
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
      end
    """
    When I go to the last author's posts
    Then the "Posts" tab should be selected
    And I should not see a menu item for "Users"
    And I should see "Displaying 1 Post"
    And I should see a link to "Users" in the breadcrumb

  Scenario: Viewing a child resource page
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
      end
    """
    When I go to the last author's posts
    And I follow "View"
    Then I should be on the last author's last post page
    And the "Posts" tab should be selected

  Scenario: When the belongs to is optional
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user, :optional => true
      end
    """
    When I go to the last author's posts
    Then the "Users" tab should be selected
    And I should see a menu item for "Posts"

    When I follow "Posts"
    Then the "Posts" tab should be selected

  Scenario: Displaying belongs to resources in main menu
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
        navigation_menu :user
      end
    """
    When I go to the last author's posts
    And I follow "View"
    Then the "Posts" tab should be selected
