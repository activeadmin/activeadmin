Feature: Decorators

  Using decorators for index and show sections

  Background:
    Given a user named "John Doe" exists
    Given a post with the title "A very unique post" exists
    And I am logged in

  Scenario: Index page with decorator
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        decorate_with PostDecorator

        index do
          column(:id)
          column(:title)
          column(:decorator_method)
        end
      end
    """
    When I am on the index page for posts
    Then I should see "A method only available on the decorator"
    And I should see "A very unique post"

  Scenario: Show page with decorator
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        decorate_with PostDecorator

        show do
          attributes_table :title, :decorator_method
        end
      end
    """
    When I am on the index page for posts
    And I follow "View"
    And I should see the attribute "Decorator Method" with "A method only available on the decorator"
    And I should see the attribute "Title" with "A very unique post"
