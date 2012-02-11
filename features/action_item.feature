Feature: Action Item

  Creating and Configuring action items

  Background:
    Given I am logged in
    And a post with the title "Hello World" exists

  Scenario: Create an member action
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      action_item do 
        link_to "Embiggen", '/'
      end  
    end
    """
    When I am on the index page for posts
    Then I should not see a member link to "Embiggen"

    When I follow "View"
    Then I should see an action item link to "Embiggen"

    When I follow "Edit Post"
    Then I should see an action item link to "Embiggen"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should see an action item link to "Embiggen"

  Scenario: Create an member action with if clause that returns true
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      action_item :if => proc{ !current_active_admin_user.nil? } do 
        link_to "Embiggen", '/'
      end  
    end
    """
    When I am on the index page for posts
    Then I should not see a member link to "Embiggen"

    When I follow "View"
    Then I should see an action item link to "Embiggen"

    When I follow "Edit Post"
    Then I should see an action item link to "Embiggen"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should see an action item link to "Embiggen"

  Scenario: Create an member action with if clause that returns false
    Given a configuration of:
    """
    ActiveAdmin.register Post do
      action_item :if => proc{ current_active_admin_user.nil? } do 
        link_to "Embiggen", '/'
      end  
    end
    """
    When I am on the index page for posts
    Then I should not see a member link to "Embiggen"

    When I follow "View"
    Then I should not see an action item link to "Embiggen"

    When I follow "Edit Post"
    Then I should not see an action item link to "Embiggen"

    When I am on the index page for posts
    When I follow "New Post"
    Then I should not see an action item link to "Embiggen"
