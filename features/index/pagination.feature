Feature: Index Pagination

  Scenario: Viewing index when one page of resources exist
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And 20 posts exist
    When I am on the index page for posts
    Then I should see "Showing all 20"
    And I should not see pagination

  Scenario: Viewing index when multiple pages of resources exist
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And 31 posts exist
    When I am on the index page for posts
    Then I should see pagination page 1 link
    And I should see pagination page 2 link

  Scenario: Viewing index with a custom per page set
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 2
      end
    """
    And 3 posts exist
    When I am on the index page for posts
    Then I should see pagination page 1 link
    And I should see pagination page 2 link
    And I should see "Showing 1-2 of 3"

  Scenario: Viewing index with pagination disabled
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        config.paginate = false
      end
    """
    And 31 posts exist
    When I am on the index page for posts
    Then I should not see pagination

  Scenario: Viewing index with pagination_total set to false
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 10
        index pagination_total: false do
        end
      end
    """
    And 11 posts exist
    When I am on the index page for posts
    Then I should see "Showing 1-10"
    And I should not see "of 11"
    And I should see the pagination "Next" link

    When I follow "Next"
    Then I should see "Showing 11-11"
    And I should not see the pagination "Next" link
