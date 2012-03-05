Feature: Belongs To

  A resource belongs to another resource

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
      end
    """
    And I am logged in
    And a post with the title "Hello World" written by "John Doe" exists
    And a post with the title "Hello World" written by "Jane Doe" exists

  Scenario: Viewing the child resource index page
    When I go to the last author's posts
    Then the "Users" tab should be selected
    And I should see "Displaying 1 Post"
    And I should see a link to "Users" in the breadcrumb

  Scenario: Viewing a child resource page
    When I go to the last author's posts
    And I follow "View"
    Then I should be on the last author's last post page
    And the "Users" tab should be selected
