Feature: Renamed Resource

  Resources renamed with as: 'NewName'

  Scenario: Default form with no config
    Given a category named "Music" exists
    And a user named "John Doe" exists
    And I am logged in
    And a configuration of:
    """
      ActiveAdmin.register Blog::Post, as: 'Post' do
        permit_params :custom_category_id, :author_id, :title,
          :body, :position, :published_date, :starred
      end
    """
    When I am on the index page for posts
    And I follow "New Post"
    And I fill in "Title" with "Hello World"
    And I fill in "Body" with "This is the body"
    And I select "Music" from "Category"
    And I select "John Doe" from "Author"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"
    And I should see the attribute "Category" with "Music"
    And I should see the attribute "Author" with "John Doe"
