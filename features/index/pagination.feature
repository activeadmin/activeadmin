Feature: Index Pagination

  Background:
  Scenario: Viewing index when one page of resources exist
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    Given 20 posts exist
    When I am on the index page for posts
    Then I should see "Displaying all 20 Posts"
    And I should not see pagination

  Scenario: Viewing index when multiple pages of resources exist
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    Given 31 posts exist
    When I am on the index page for posts
    Then I should see pagination with 2 pages

  Scenario: Viewing index with a custom per page set
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        before_filter :only => :index do |controller|
          @per_page = 10
        end
      end
    """
    Given 11 posts exist
    When I am on the index page for posts
    Then I should see pagination with 2 pages
    And I should see "Displaying Posts 1 - 10 of 11 in total"
