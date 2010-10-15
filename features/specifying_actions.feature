Feature: Specifying Actions

  Specifying which actions to allow on my resource

  @allow-rescue  
  Scenario: Only creating the index action
    Given a configuration of:
      """
        ActiveAdmin.register Post do
          actions :index
        end
      """
	And I am logged in
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    Then an "AbstractController::ActionNotFound" exception should be raised when I follow "View"
