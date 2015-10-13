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

  Scenario: Form page with decorator
    Given a user named "John Doe" exists
    And a profile with the bio "Good guy" exists
    And I am logged in
    And a configuration of:
    """
      ActiveAdmin.register User do
        decorate_with UserDecorator
        permit_params :profile_id if Rails::VERSION::MAJOR == 4

        show do
          attributes_table :profile
        end

        form decorate: true do |f|
          f.inputs do
            f.input :profile, as: :select
          end
          f.actions
        end
      end
    """
    When I am on the index page for users
    And I follow "New User"
    And I select "Good guy" from "Profile"
    And I press "Create User"
    Then I should see "User was successfully created."
    And I should see the attribute "Profile" with "Good guy"
