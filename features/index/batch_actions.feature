Feature: Batch Actions

  Scenario: Viewing resource with default batch action

    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post
      """

    Then I should see the batch action button
	And I should see that the batch action button is disabled
    And I should see the batch action popover exist
	And I should see the batch action :destroy "Delete Selected"
	And I should be asked to confirm "Are you sure you want to delete?" for "Delete Selected"

  # TODO: Integrate with JS testing	
  #@selenium
  Scenario: Toggling records

	Given 10 posts exist
	And an index configuration of:
	  """
	  ActiveAdmin.register Post
	  """
	
	When I check the 1st record
	Then I should see 1 record selected
	
	When I uncheck the 1st record
	Then I should see 0 records selected
	
	# When I toggle the collection selection
	# Then I should see 10 records selected
	# 
	# When I toggle the collection selection
	# Then I should see 0 records selected
	# 
	# When I check the 1st record
	# When I toggle the collection selection
	# Then I should see 10 records selected
	
  Scenario: Disabling batch actions
	
	Given 10 posts exist
	And an index configuration of:
	  """
	  ActiveAdmin.register Post do
		batch_action :destroy, false
	  end
	  """
	
	Then I should not see the batch action :destroy "Delete Selected"
	
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
