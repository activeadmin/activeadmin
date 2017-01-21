Feature: Index Scope To

  Viewing resource configs scoped to another object

  Background:
    Given 10 posts exist
    And a post with the title "Hello World" written by "John Doe" exists
    And a published post with the title "Hello World" written by "John Doe" exists
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        # Scope section to a specific author
        scope_to do
          User.find_by_first_name_and_last_name "John", "Doe"
        end

        # Set up some scopes
        scope :all, default: true
        scope :published do |posts|
          posts.where "published_date IS NOT NULL"
        end
      end
      """

  Scenario: Viewing the default scope counts
    When I am on the index page for posts
    Then I should see the scope "All" selected
    And I should see the scope "All" with the count 2
    And I should see 2 posts in the table

    When I follow "Published"
    Then I should see 1 posts in the table

  Scenario: Viewing the index with conditional scope :if
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        scope_to if: proc{ false } do
          User.find_by_first_name_and_last_name("John", "Doe")
        end
      end
      """
    When I am on the index page for posts
    Then I should see 12 posts in the table

  Scenario: Viewing the index with conditional scope :unless
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        scope_to unless: proc{ true } do
          User.find_by_first_name_and_last_name("John", "Doe")
        end
      end
      """
    When I am on the index page for posts
    Then I should see 12 posts in the table
