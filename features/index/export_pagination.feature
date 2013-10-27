Feature: Index Export Pagination

  Background:
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And 20 posts exist

  Scenario: Export with only start parameter set
    When I am on the index page for posts with params "?export%5Bstart%5D=5"
    Then the table "#index_table_posts" should have 16 rows (including the header row)

  Scenario: Export with only end parameter set
    When I am on the index page for posts with params "?export%5Bend%5D=5"
    Then the table "#index_table_posts" should have 6 rows (including the header row)

  Scenario: Export with start and end parameter set
    When I am on the index page for posts with params "?export%5Bstart%5D=5&export%5Bend%5D=15"
    Then the table "#index_table_posts" should have 11 rows (including the header row)