Feature: Show - Tabs

  Add tabs with different content to the page

  Background:
    Given a post with the title "Hello World" written by "Jane Doe" exists

  Scenario: Set a method to be called on the resource as the title
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        show do
          tabs do
            tab :overview do
              span "tab 1"
            end

            tab :details do
              span "tab 2"
            end
          end
        end
      end
    """
    Then I should see two tabs "Overview" and "Details"
    And I should see "tab 1"
    And I should see "tab 2"
