Feature: Index Formats

  Scenario: View index with default formats
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    Then I should see a link to download "CSV"
    And I should see a link to download "XML"
    And I should see a link to download "JSON"
