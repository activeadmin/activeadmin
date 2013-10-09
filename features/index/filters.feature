Feature: Index Filtering

  Scenario: Default Resources Filters
    Given 3 posts exist
    And an index configuration of:
    """
      ActiveAdmin.register Post
    """
    When I am on the index page for posts
    Then I should see "Displaying all 3 Posts"
    And I should see the following filters:
     | Author       | select     |
     | Category     | select     |
     | Title        | string     |
     | Body         | string     |
     | Published at | date range |
     | Created at   | date range |
     | Updated at   | date range |

    When I fill in "Title" with "Hello World 2"
    And I press "Filter"
    And I should see 1 posts in the table
    And I should see "Hello World 2" within ".index_table"

  Scenario: Filtering posts with no results
    Given 3 posts exist
    And an index configuration of:
    """
      ActiveAdmin.register Post
    """
    When I am on the index page for posts
    Then I should see "Displaying all 3 Posts"

    When I fill in "Title" with "THIS IS NOT AN EXISTING TITLE!!"
    And I press "Filter"
    Then I should not see ".index_table"
    And I should not see a sortable table header
    And I should not see pagination
    And I should see "No Posts found"

  Scenario: Filtering posts while not on the first page
    Given 9 posts exist
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 5
      end
    """
    When I follow "2"
    Then I should see "Displaying Posts 6 - 9 of 9 in total"

    When I fill in "Title" with "Hello World 2"
    And I press "Filter"
    And I should see 1 posts in the table
    And I should see "Hello World 2" within ".index_table"

  Scenario: Checkboxes - Filtering posts written by anyone
    Given 1 post exists
    And a post with the title "Hello World" written by "Jane Doe" exists
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        filter :author, :as => :check_boxes
      end
    """
    When I press "Filter"
    Then I should see 2 posts in the table
    And I should see "Hello World" within ".index_table"
    And the "Jane Doe" checkbox should not be checked

  Scenario: Checkboxes - Filtering posts written by Jane Doe
    Given 1 post exists
    And a post with the title "Hello World" written by "Jane Doe" exists
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        filter :author, :as => :check_boxes
      end
    """
    When I check "Jane Doe"
    And I press "Filter"
    Then I should see 1 posts in the table
    And I should see "Hello World" within ".index_table"
    And the "Jane Doe" checkbox should be checked

  Scenario: Disabling filters
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        config.filters = false
      end
    """
    Then I should not see a sidebar titled "Filters"

  Scenario: Select - Filtering categories with posts written by Jane Doe
    Given a category named "Mystery" exists
    And 1 post with the title "Hello World" written by "Jane Doe" in category "Non-Fiction" exists
    And an index configuration of:
    """
      ActiveAdmin.register Category
    """
    When I select "Jane Doe" from "Authors"
    And I press "Filter"
    Then I should see 1 categories in the table
    And I should see "Non-Fiction" within ".index_table"
    And I should not see "Mystery" within ".index_table"

  Scenario: Checkboxes - Filtering categories via posts written by anyone
    Given a category named "Mystery" exists
    And a post with the title "Hello World" written by "Jane Doe" in category "Non-Fiction" exists
    And an index configuration of:
    """
      ActiveAdmin.register Category do
        filter :authors, :as => :check_boxes
      end
    """
    When I press "Filter"
    Then I should see 2 posts in the table
    And I should see "Mystery" within ".index_table"
    And I should see "Non-Fiction" within ".index_table"
    And the "Jane Doe" checkbox should not be checked

  Scenario: Checkboxes - Filtering categories via posts written by Jane Doe
    Given a category named "Mystery" exists
    And a post with the title "Hello World" written by "Jane Doe" in category "Non-Fiction" exists
    And an index configuration of:
    """
      ActiveAdmin.register Category do
        filter :authors, :as => :check_boxes
      end
    """
    When I check "Jane Doe"
    And I press "Filter"
    Then I should see 1 categories in the table
    And I should see "Non-Fiction" within ".index_table"
    And the "Jane Doe" checkbox should be checked


