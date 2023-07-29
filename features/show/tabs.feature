@javascript
Feature: Show - Tabs

  Add tabs with different content to the page

  Scenario: Set a method to be called on the resource as the title
    Given a post with the title "Hello World" written by "Jane Doe" exists

    And a configuration of:
    """
      ActiveAdmin.register Post do
        show do
          tabs do
            tab :overview do
              span "tab 1"
            end

            tab 'Profile', id: :custom_id do
              span "tab 2"
            end
          end
        end
      end
    """

    And I am logged in
    And I am on the post's show page

    Then I should see tabs:
    | Tab title |
    | Overview  |
    | Profile   |
    And I should see tab content "tab 1"
    And I should not see tab content "tab 2"

    When I press "Profile"
    Then I should not see tab content "tab 1"
    And I should see tab content "tab 2"
