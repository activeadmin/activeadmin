Feature: Default Sorting
  Scenario: View Index without a default sort order
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
      end
    """
    Given 2 posts exist
    When I am on the index page for posts
    Then I should see the posts ordered by descending "id"

  Scenario: View Index with a default sort order
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        default_sort :title_asc
      end
    """
    Given 2 posts exist
    When I am on the index page for posts
    Then I should see the posts ordered by ascending "title"


  Scenario: View Index with a default sort with an if condition
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        default_sort :title_asc, :if => Proc.new{ false }
      end
    """
    Given 2 posts exist
    When I am on the index page for posts
    Then I should see the posts ordered by descending "id"

  Scenario: View Index with a default sort with an unless condition
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        default_sort :title_asc, :unless => Proc.new{ true }
      end
    """
    Given 2 posts exist
    When I am on the index page for posts
    Then I should see the posts ordered by descending "id"
