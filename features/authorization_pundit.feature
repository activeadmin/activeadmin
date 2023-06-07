@authorization
Feature: Authorizing Access using Pundit

  Background:
    Given I am logged in
    And 1 post exists
    And a configuration of:
    """
    require 'pundit'

    ActiveAdmin.application.namespace(:admin).authorization_adapter = ActiveAdmin::PunditAdapter

    ActiveAdmin.register Post do
    end

    ActiveAdmin.register_page "No Access" do
    end
    """
    And I am on the index page for posts

  Scenario: Attempt to access a resource I am not authorized to see
    When I go to the last post's edit page
    Then I should see "You are not authorized to perform this action"

  Scenario: Viewing the default action items
    When I follow "View"
    Then I should not see an action item link to "Edit"

  Scenario: Attempting to visit a Page without authorization
    When I go to the admin no access page
    Then I should see "You are not authorized to perform this action"

  Scenario: Viewing a page with authorization
    When I go to the admin dashboard page
    Then I should see "Dashboard"

  Scenario: Comment policy allows access to my own comments only
    Given 5 comments added by admin with an email "commenter@example.com"
    And 3 comments added by admin with an email "admin@example.com"
    When I am on the dashboard
    Then I should see a menu item for "Comments"
    When I go to the index page for comments
    Then I should see 3 Comments in the table
    When I go to the last post's show page
    Then I should see 3 comments
    And I should be able to add a comment
