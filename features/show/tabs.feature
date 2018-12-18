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

            tab '🤗' do
              span "tab 3"
            end
          end
        end
      end
    """

    Then I should see tabs:
    | Tab title |
    | Overview  |
    | テスト     |
    | 🤗        |
    And I should see tab content "tab 1"
    And I should not see tab content "tab 2"
    And I should not see tab content "tab 3"
    Then I follow "テスト"
    And I should not see tab content "tab 1"
    And I should see tab content "tab 2"
    And I should not see tab content "tab 3"
    Then I follow "🤗"
    And I should not see tab content "tab 1"
    And I should not see tab content "tab 2"
    And I should see tab content "tab 3"
