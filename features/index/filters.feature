Feature: Index Pagination

  Background:
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
  Scenario: Filtering posts
    Given 20 posts exist
    When I am on the index page for posts
    Then I should see "Displaying all 20 Posts"
    And I should see "Author" within ".filter_form"
    And I should see "Category" within ".filter_form"
    And I should see "Search Title" within ".filter_form"
    And I should see "Search Body" within ".filter_form"
    And I should see "Published at" within ".filter_form"
    And I should see "Created at" within ".filter_form"
    And I should see "Updated at" within ".filter_form"
    
    When I fill in "Search Title" with "Hello World 17"
    And I press "Filter"
    And I should see 1 posts in the table
    And I should see "Hello World 17" within ".index_table"
    
  Scenario: Filtering posts with no results
    Given 20 posts exist
    When I am on the index page for posts
    Then I should see "Displaying all 20 Posts"
    When I fill in "Search Title" with "THIS IS NOT AN EXISTING TITLE!!"
    And I press "Filter"
    And show me the page
    
    And I should not see ".index_table"
    Then I should see a sortable table header with "ID"
    And I should see a sortable table header with "Title"
    And I should not see pagination
    And I should see "No Posts found"
