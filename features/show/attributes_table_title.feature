Feature: Show - Attributes Table Title
  
  Modifying the title of the panel wrapping the attributes table
  
  Background:
    Given a post with the title "Hello World" written by "Jane Doe" exists
  
  Scenario: Set a string as the title
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        show do
          attributes_table title: "Title From String"
        end
      end
    """
    Then I should see the panel title "Title From String"
    And I should see the attributes table
  
  Scenario: Set a method to be called on the resource as the title
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        show do
          attributes_table title: :title
        end
      end
    """
    Then I should see the panel title "Hello World"
    And I should see the attributes table
  
  Scenario: Set a proc as the title
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        show do
          attributes_table title: proc{ |post| "Title: #{post.title}" }
        end
      end
    """
    Then I should see the panel title "Title: Hello World"
    And I should see the attributes table
  
  Scenario: Should not accept other keys
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        show do
          attributes_table foo: "Title From String"
        end
      end
    """
    Then I should not see the panel title "Title From String"
    And I should see the attributes table
