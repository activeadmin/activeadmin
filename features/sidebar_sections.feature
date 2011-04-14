Feature: Sidebar Sections

  Creating and Configuring sidebar sections

  Background:
    Given I am logged in
    And a post with the title "Hello World" exists


  Scenario: Create a sidebar for all actions
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help do
        "Need help? Email us at help@example.com"
      end
    end
    """
    When I am on the index page for posts
    Then I should see a sidebar titled "Help"
    Then I should see /Need help/ within the sidebar "Help"

    When I follow "View"
    Then I should see a sidebar titled "Help"

    When I follow "Edit Post"
    Then I should see a sidebar titled "Help"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should see a sidebar titled "Help"


  Scenario: Create a sidebar for only one action
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help, :only => :index do
        "Need help? Email us at help@example.com"
      end
    end
    """
    When I am on the index page for posts
    Then I should see a sidebar titled "Help"
    Then I should see /Need help/ within the sidebar "Help"

    When I follow "View"
    Then I should not see a sidebar titled "Help"

    When I follow "Edit Post"
    Then I should not see a sidebar titled "Help"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should not see a sidebar titled "Help"


  Scenario: Create a sidebar for all except one action
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      sidebar :help, :except => :index do
        "Need help? Email us at help@example.com"
      end
    end
    """
    When I am on the index page for posts
    Then I should not see a sidebar titled "Help"

    When I follow "View"
    Then I should see a sidebar titled "Help"

    When I follow "Edit Post"
    Then I should see a sidebar titled "Help"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should see a sidebar titled "Help"
