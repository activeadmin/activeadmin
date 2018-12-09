@javascript
Feature: Show - Tabs

  Add tabs with different content to the page

  Scenario: Set a method to be called on the resource as the title
    Given a post with the title "Hello World" written by "Jane Doe" exists

    And a show configuration of:
    """
      ActiveAdmin.register Post do
        show do
          tabs do
            tab :overview do
              span "tab 1"
            end

            tab 'テスト', id: :test_non_ascii do
              span "tab 2"
            end
          end
        end
      end
    """

    Then I should see two tabs "Overview" and "テスト"
    And I should see the element "#overview span"
    And I should not see the element "#test_non_ascii span"
    When I follow "テスト"
    Then I should see the element "#test_non_ascii span"
    And I should not see the element "#overview span"
