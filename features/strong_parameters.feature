@silent_unpermitted_params_failure
Feature: Strong Params

  Background:
    Given a category named "Music" exists
    And a user named "John Doe" exists
    And a post with the title "Hello World" written by "John Doe" exists
    And I am logged in
    And a configuration of:
    """
      ActiveAdmin.register Post do
      end
    """
    And I am on the index page for posts

  Scenario: Static permitted parameters
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :author, :title, :starred
      end
    """
    When I follow "Edit"

    And I fill in "Title" with "Hello World from update"
    And I check "Starred"
    And I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"
    And I should see the attribute "Starred" with "Yes"

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
    When I follow "Edit"

    And I fill in "Title" with "Hello World from update"
    And I check "Starred"
    And I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"
    And I should see the attribute "Starred" with "Yes"

  Scenario: Should not update parameters that are not declared as permitted
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :author, :title
      end
    """
    When I follow "Edit"

    And I fill in "Title" with "Hello World from update"
    And I check "Starred"
    And I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"
    And I should see the attribute "Starred" with "No"
