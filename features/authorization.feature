@authorization
Feature: Authorizing Access

  Ensure that access denied exceptions are managed

  Background:
    Given I am logged in
    And 1 post exists
    And a configuration of:
    """
    class OnlyAuthorsAuthorization < ActiveAdmin::AuthorizationAdapter

      def authorized?(action, subject = nil)
        case subject

        when normalized(Post)
          case action
          when :update, :destroy
            false
          else
            true
          end

        when ActiveAdmin::Page
          if subject.name == "No Access"
            false
          else
            true
          end

        else
          false
        end
      end

    end

    ActiveAdmin.application.namespace(:admin).authorization_adapter = OnlyAuthorsAuthorization

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
