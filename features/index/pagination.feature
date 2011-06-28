Feature: Index Pagination

  Background:
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
  Scenario: Viewing index when one page of resources exist
    Given 20 posts exist
    When I am on the index page for posts
    Then I should see "Displaying all 20 Posts"
    And I should not see pagination

  Scenario: Viewing index when multiple pages of resources exist
    Given 31 posts exist
    When I am on the index page for posts
    Then I should see pagination with 2 pages
