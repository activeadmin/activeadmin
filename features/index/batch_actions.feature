Feature: Batch Actions

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
    When I check the 2nd record
    And I follow "Batch Actions"
    Then I should see the batch action :destroy "Delete Selected"


    Given I submit the batch action form with "destroy"
    Then I should see a flash with "Successfully destroyed 1 post"
    And I should see 9 posts in the table

  Scenario: Using a custom batch action
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
      batch_action( :flag ) do
      redirect_to collection_path, :notice => "Successfully flagged 10 posts" 
      end
      end
      """
    When I check the 1st record
    Given I submit the batch action form with "flag"
    Then I should see a flash with "Successfully flagged 10 posts"
  
  Scenario: Disabling batch actions
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
      batch_action :destroy, false
      end
      """
    Then I should not see the batch action :destroy "Delete Selected"
    And I should not see checkboxes in the table
  
  Scenario: Optional display of batch actions
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
      batch_action( :flag, :if => proc { true } ) {}
      batch_action( :unflag, :if => proc { false } ) {}
      end
      """
    Then I should see the batch action "Flag Selected"
    And I should not see the batch action "Unflag Selected"
    
  Scenario: Sort order priority
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
      batch_action( :test, :priority => 3 ) {}
      batch_action( :flag, :priority => 2 ) {}
      batch_action( :unflag, :priority => 1 ) {}
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
      batch_action( "Very Complex and Time Consuming" ) {}
      batch_action( :passing_a_symbol ) {}
      end
      """
    Then I should see the batch action :very_complex_and_time_consuming "Very Complex and Time Consuming Selected"
    And I should see the batch action :passing_a_symbol "Passing A Symbol Selected"
