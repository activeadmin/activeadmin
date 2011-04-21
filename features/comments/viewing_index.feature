Feature: Viewing Index of Comments

  Background:
    Given a post with the title "Hello World" written by "Jane Doe" exists
    Given a show configuration of:
      """
        ActiveAdmin.register Post
      """

  Scenario: Viewing all commments for a namespace
    When I add a comment "Hello from Comment"
    When I am on the index page for comments
    Then I should see a table header with "Body"
    And I should see a table header with "Resource"
    And I should see a table header with "Author"
    And I should see "Hello from Comment"
    And I should see a link to "Hello World"
    And I should see "admin@example.com"
    And I should not see an action item button "New Comment"
