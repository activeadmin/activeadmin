Feature: Filter with check boxes

  Background:
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        filter :author, :as => :check_boxes
      end
    """
    And a post with the title "Hello World" written by "Jane Doe" exists
    And 1 post exists
    And I am on the index page for posts

  Scenario: Filtering posts written by anyone
    When I press "Filter"
    Then I should see 2 posts in the table
    And I should see "Hello World" within ".index_table"
    And the "jane_doe" checkbox should not be checked

  Scenario: Filtering posts written by Jane Doe
    When I check "jane_doe"
    And I press "Filter"
    Then I should see 1 posts in the table
    And I should see "Hello World" within ".index_table"
    And the "jane_doe" checkbox should be checked
