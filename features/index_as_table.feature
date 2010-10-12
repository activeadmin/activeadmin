Feature: Index as Table

  Viewing resources as a table

  Scenario: Viewing the default table with no resources
    Given a configuration of:
      """
        ActiveAdmin.register Post
      """
    When I am on the index page for posts
    Then I should see a table header with "ID"
    And I should see a table header with "Title"

  Scenario: Viewing the default table with a resource
    Given a post with the title "Hello World" exists
    And a configuration of:
      """
        ActiveAdmin.register Post
      """
    When I am on the index page for posts
    Then I should see "Hello World"
    And I should see a link to "View"
    And I should see a link to "Edit"
    And I should see a link to "Delete"
