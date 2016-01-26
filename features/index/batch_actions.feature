Feature: Batch Actions

  @javascript
  Scenario: Use default (destroy) batch action
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post
      """
    Then I should see the batch action button
    And I should see that the batch action button is disabled
    And I should see the batch action popover exists
    And I should see 10 posts in the table

    When I check the 1st record
    And I check the 2nd record
    And I follow "Batch Actions"
    Then I should see the batch action :destroy "Delete Selected"

    Given I click "Delete Selected" and accept confirmation
    Then I should see a flash with "Successfully destroyed 2 posts"
    And I should see 8 posts in the table

  Scenario: Use default (destroy) batch action on a decorated resource
    Given 5 posts exist
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        decorate_with PostDecorator
      end
    """
    When I check the 2nd record
    And I check the 4th record
    And I follow "Batch Actions"
    Then I should see the batch action :destroy "Delete Selected"

    Given I submit the batch action form with "destroy"
    Then I should see a flash with "Successfully destroyed 2 posts"
    And I should see 3 posts in the table

  @javascript
  Scenario: Use default (destroy) batch action on a nested resource
    Given I am logged in
    And 5 posts written by "John Doe" exist
    And a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
      end
    """
    When I go to the last author's posts
    Then I should see the batch action button
    And I should see that the batch action button is disabled
    And I should see the batch action popover exists
    And I should see 5 posts in the table

    When I check the 2nd record
    And I check the 4th record
    And I follow "Batch Actions"
    Then I should see the batch action :destroy "Delete Selected"

    Given I click "Delete Selected" and accept confirmation
    Then I should see a flash with "Successfully destroyed 2 posts"
    And I should see 3 posts in the table

  Scenario: Disable display of batch action button if all nested buttons hide
    Given 1 post exist
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        batch_action :destroy, false
        batch_action(:flag, if: proc { false } ) do
          render text: 42
        end
      end
      """
    Then I should not see the batch action selector

  Scenario: Using a custom batch action
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action(:flag) do
          redirect_to collection_path, :notice => "Successfully flagged 10 posts"
        end
      end
      """
    When I check the 1st record
    Given I submit the batch action form with "flag"
    Then I should see a flash with "Successfully flagged 10 posts"

  Scenario: Disabling batch actions for a resource
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        config.batch_actions = false
      end
      """
    Then I should not see the batch action selector
    And I should not see checkboxes in the table

  Scenario: Disabling the default destroy batch action
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action :destroy, false
        batch_action(:flag) {}
      end
      """
    Then I should see the batch action :flag "Flag Selected"
    And I should not see the batch action :destroy "Delete Selected"

  Scenario: Optional display of batch actions
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action(:flag, :if => proc { true }) {}
        batch_action(:unflag, :if => proc { false }) {}
      end
      """
    Then I should see the batch action :flag "Flag Selected"
    And I should not see the batch action :unflag "Unflag Selected"

  Scenario: Sort order priority
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action(:test, :priority => 3) {}
        batch_action(:flag, :priority => 2) {}
        batch_action(:unflag, :priority => 1) {}
      end
      """
    Then the 4th batch action should be "Delete Selected"
    And the 3rd batch action should be "Test Selected"
    And the 2nd batch action should be "Flag Selected"
    And the 1st batch action should be "Unflag Selected"

  Scenario: Complex naming
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action("Very Complex and Time Consuming") {}
        batch_action(:passing_a_symbol) {}
      end
      """
    Then I should see the batch action :very_complex_and_time_consuming "Very Complex and Time Consuming Selected"
    And I should see the batch action :passing_a_symbol "Passing A Symbol Selected"

  Scenario: Use a Form with text
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action :destroy, false
        batch_action(:action_with_form, form: { name: :text }) {}
      end
      """

    When I check the 1st record
    And I follow "Batch Actions"
    Then I should be show a input with name "name" and type "text"

  Scenario: Use a Form with select
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action :destroy, false
        batch_action(:action_with_form, form: { type: ["a", "b"] }) {}
      end
      """

    When I check the 1st record
    And I follow "Batch Actions"
    Then I should be show a select with name "type" with the values "a, b"

  Scenario: Use a Form with select values from proc
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        batch_action :destroy, false
        batch_action(:action_with_form, form: ->{ {type: ["a", "b"]} }) {}
      end
      """

    When I check the 1st record
    And I follow "Batch Actions"
    Then I should be show a select with name "type" with the values "a, b"
