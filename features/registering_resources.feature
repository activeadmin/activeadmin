Feature: Registering Resources

  Registering resources within Active Admin

  Background:
    Given I am logged in
    And a post with the title "Hello World" exists

  Scenario: Registering a resource with the defaults
    Given a configuration of:
    """ 
      ActiveAdmin.register Post
    """
    When I go to the dashboard
    Then I should see "Posts"
    When I follow "Posts"
    Then I should see "Hello World"
    When I follow "View"
    Then I should see "Hello World"
    And I should be in the resource section for Post

  Scenario: Registering a resource with another name
    Given a configuration of:
    """ 
      ActiveAdmin.register Post, :as => "My Post"
    """
    When I go to the dashboard
    Then I should see "My Posts"
    When I follow "My Posts"
    Then I should see "Hello World"
    When I follow "View"
    Then I should see "Hello World"
    And I should be in the resource section for My Post
