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
    And I should see "Displaying Posts 1 - 30 of 31 in total"

  Scenario: Viewing last page of index when multiple pages of resources exist
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    Given 34 posts exist
    And I am on the index page for posts
    When I follow "Last »"
    Then I should see "Displaying Posts 31 - 34 of 34 in total"

  Scenario: Viewing index with a custom per page set
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 2
      end
    """
    Given 3 posts exist
    When I am on the index page for posts
    Then I should see pagination with 2 pages
    And I should see "Displaying Posts 1 - 2 of 3 in total"

  Scenario: Viewing index with pagination disabled
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        config.paginate = false
      end
    """
    Given 31 posts exist
    When I am on the index page for posts
    Then I should not see pagination
