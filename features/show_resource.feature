Feature: Show Resource

  Viewing the show page for a resource

  Background:
    Given a post with the title "Hello World" written by "Jane Doe" exists

  Scenario: Viewing the default show page
    Given a show configuration of:
      """
        ActiveAdmin.register Post
      """
    Then I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "Empty"
    And I should see the attribute "Author" with "jane_doe"

  Scenario: Attributes should link when linked resource is registered
    Given a show configuration of:
      """
        ActiveAdmin.register User
        ActiveAdmin.register Post
      """
    Then I should see the attribute "Author" with "jane_doe"
    And I should see a link to "jane_doe"
