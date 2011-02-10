Feature: Index as Table

  Viewing resources as a table on the index page

  Scenario: Viewing the default table with no resources
    Given an index configuration of:
      """
        ActiveAdmin.register Post
      """
    Then I should see a table header with "ID"
    And I should see a table header with "Title"

  Scenario: Viewing the default table with a resource
    Given a post with the title "Hello World" exists
    And an index configuration of:
      """
        ActiveAdmin.register Post
      """
    Then I should see "Hello World"
    And I should see a link to "View"
    And I should see a link to "Edit"
    And I should see a link to "Delete"
