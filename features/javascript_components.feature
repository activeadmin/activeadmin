@javascript
Feature: JavaScript UI Components

  Dropdown, modal, and drawer interactions powered by custom JS.

  Scenario: User menu dropdown opens and closes via toggle
    Given I am logged in
    When I go to the dashboard
    Then I should see "Dashboard"
    When I click the element "[data-dropdown-toggle='user-menu']"
    Then I should see the element "#user-menu"
    When I click the element "[data-dropdown-toggle='user-menu']"
    Then I should not see the element "#user-menu"

  Scenario: User menu dropdown closes on Escape key
    Given I am logged in
    When I go to the dashboard
    And I click the element "[data-dropdown-toggle='user-menu']"
    Then I should see the element "#user-menu"
    When I press the Escape key
    Then I should not see the element "#user-menu"

  Scenario: User menu dropdown closes on outside click
    Given I am logged in
    When I go to the dashboard
    And I click the element "[data-dropdown-toggle='user-menu']"
    Then I should see the element "#user-menu"
    When I click the element "[data-test-page-content]"
    Then I should not see the element "#user-menu"

  Scenario: Batch actions dropdown closes on Escape key
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post
      """
    When I check the 1st record
    And I press "Batch Actions"
    Then I should see the batch action :destroy "Delete Selected"
    When I press the Escape key
    Then I should not see the batch action :destroy "Delete Selected"

  Scenario: Modal closes on Escape key
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action :set_starred, partial: "starred_batch_action_form", link_html_options: { "data-modal-target": "starred-batch-action-modal", "data-modal-show": "starred-batch-action-modal" } do |ids, inputs|
          redirect_to collection_path, notice: "Done"
        end
      end
      """
    When I check the 1st record
    And I press "Batch Actions"
    And I click "Set Starred"
    Then I should see "Toggle Starred"
    When I press the Escape key
    Then I should not see "Toggle Starred"

  Scenario: Modal closes on X button click
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action :set_starred, partial: "starred_batch_action_form", link_html_options: { "data-modal-target": "starred-batch-action-modal", "data-modal-show": "starred-batch-action-modal" } do |ids, inputs|
          redirect_to collection_path, notice: "Done"
        end
      end
      """
    When I check the 1st record
    And I press "Batch Actions"
    And I click "Set Starred"
    Then I should see "Toggle Starred"
    When I click the element "[data-modal-hide='starred-batch-action-modal']"
    Then I should not see "Toggle Starred"

  Scenario: Modal closes on backdrop click
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action :set_starred, partial: "starred_batch_action_form", link_html_options: { "data-modal-target": "starred-batch-action-modal", "data-modal-show": "starred-batch-action-modal" } do |ids, inputs|
          redirect_to collection_path, notice: "Done"
        end
      end
      """
    When I check the 1st record
    And I press "Batch Actions"
    And I click "Set Starred"
    Then I should see "Toggle Starred"
    When I click the modal backdrop
    Then I should not see "Toggle Starred"
