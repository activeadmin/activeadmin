Feature: Export Behaviour

  Allow developers to change the behaviour when exporting
  records from ActiveAdmin

  Background:
    And a post with the title "Hello World" exists
    And a post with the title "Hello World 2" exists
    And I am logged in

  Scenario: Default should show a modal
    Given a configuration of:
    """
      ActiveAdmin.register Post do

      end
    """
    When I am on the index page for posts
    Then the "CSV" link should have the "data-export-modal" attribute

  Scenario: Show a modal dialog
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.export_behaviour = :modal
      end
    """
    When I am on the index page for posts
    Then the "CSV" link should have the "data-export-modal" attribute

  Scenario: Export all
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 1

        config.export_behaviour = :all
      end
    """
    When I am on the index page for posts
    Then the "CSV" link should not have the "data-export-modal" attribute

    When I click "CSV"
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
    Then the "CSV" link should not have the "data-export-modal" attribute

    When I click "CSV"
    And I should download a CSV file for "posts" containing:
    | Id  | Title         | Body | Published At | Starred | Created At | Updated At |
    | \d+ | Hello World 2 |      |              |         | (.*)       | (.*)       |