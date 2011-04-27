Feature: Global Navigation


  Background:
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    Given I am logged in
    And 10 posts exist

  Scenario: Viewing the current section in the global navigation
    Given I am on the index page for posts
    Then the "Posts" tab should be selected

  Scenario: Viewing the current section in the global navigation when on new page
    Given I am on the index page for posts
    And I follow "New Post"
    Then the "Posts" tab should be selected

  Scenario: Viewing the current section in the global navigation when on show page
    Given I am on the index page for posts
    And I follow "View"
    Then the "Posts" tab should be selected

  Scenario: Viewing the current section in the global navigation when on edit page
    Given I am on the index page for posts
    And I follow "View"
    And I follow "Edit Post"
    Then the "Posts" tab should be selected
