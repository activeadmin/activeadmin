Feature: Development Reloading

  In order to quickly develop applications
  As a developer
  I want the application to reload itself in development

  @requires-reloading
  Scenario: Reloading an updated model that a resource points to
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    And I am logged in
    And I create a new post with the title ""
    Then I should see a successful create flash
    Given I add "validates_presence_of :title" to the "post" model
    And I create a new post with the title ""
    Then I should not see a successful create flash
    And I should see a validation error "can't be blank"
