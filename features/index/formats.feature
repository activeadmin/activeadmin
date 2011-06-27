Feature: Index Formats

  Scenario: View index with default formats
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And 1 post exists
    When I am on the index page for posts
    Then I should see a link to download "CSV"
    And I should see a link to download "XML"
    And I should see a link to download "JSON"
