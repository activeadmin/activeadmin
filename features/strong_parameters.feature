@rails4
Feature: Strong Params

  When I am using Rails 4
  I want to use Strong Parameters

  Background:
    Given a category named "Music" exists
    And a user named "John Doe" exists
    And a post with the title "Hello World" written by "John Doe" exists
    And I am logged in
    Given a configuration of:
    """
      ActiveAdmin.register Post do
      end
    """
    When I am on the index page for posts

  Scenario: Static permitted parameters
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :author, :title, :starred
      end
    """
    Given I follow "Edit"

    When I fill in "Title" with "Hello World from update"
    And I check "Starred"
    When I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"
    And I should see the attribute "Starred" with "true"

  Scenario: Dynamic permitted parameters
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params do
          allow = [:author, :title]
          allow << :starred
          allow
        end
      end
    """
    Given I follow "Edit"

    When I fill in "Title" with "Hello World from update"
    And I check "Starred"
    When I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"
    And I should see the attribute "Starred" with "true"

  Scenario: Should not update parameters that are not declared as permitted
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :author, :title
      end
    """
    Given I follow "Edit"

    When I fill in "Title" with "Hello World from update"
    And I check "Starred"
    When I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"
    And the attribute "Starred" should be empty
