Feature: Export Behaviour

  Allow developers to change the behaviour when exporting
  records from ActiveAdmin

  Background:
    And a post with the title "Hello World" exists
    And a post with the title "Hello World 2" exists
    And I am logged in

  @javascript
  Scenario: Default should show a modal
    Given a configuration of:
    """
      ActiveAdmin.register Post do

      end
    """
    When I am on the index page for posts
    And I click "CSV"
    Then I should see a dialog

  @javascript
  Scenario: Show a modal dialog
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.export_behaviour = :modal
      end
    """
    When I am on the index page for posts
    And I click "CSV"
    Then I should see a dialog

  Scenario: Export all
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 1

        config.export_behaviour = :all
      end
    """
    When I am on the index page for posts
    And I click "CSV"
    And I should download a CSV file for "posts" containing:
    | Id  | Title         | Body | Published At | Starred | Created At | Updated At |
    | \d+ | Hello World 2 |      |              |         | (.*)       | (.*)       |
    | \d+ | Hello World   |      |              |         | (.*)       | (.*)       |

  Scenario: Export current page
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 1

        config.export_behaviour = :paginate
      end
    """
    When I am on the index page for posts
    And I click "CSV"
    And I should download a CSV file for "posts" containing:
    | Id  | Title         | Body | Published At | Starred | Created At | Updated At |
    | \d+ | Hello World 2 |      |              |         | (.*)       | (.*)       |