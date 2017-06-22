Feature: Create Another checkbox

  Background:
    Given I am logged in

  Scenario: On a new page
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.create_another = true

        permit_params :custom_category_id, :author_id, :title,
          :body, :position, :published_date, :starred
      end
    """
    Then I am on the index page for posts
    And I follow "New Post"
    When I fill in "Title" with "Hello World"
    And I fill in "Body" with "This is the body"
    And the "Create another Post" checkbox should not be checked
    And I check "Create another"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see "New Post"
    And the "Create another" checkbox should be checked
    When I fill in "Title" with "Another Hello World"
    And I fill in "Body" with "This is the another body"
    And I uncheck "Create another"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Another Hello World"
    And I should see the attribute "Body" with "This is the another body"

  Scenario: Application config of false and a resource config of true
    Given a configuration of:
    """
      ActiveAdmin.application.create_another = false
      ActiveAdmin.register Post do
        config.create_another = true
      end
    """
    When I am on the new post page
    Then I should see the element ".create_another"
    Then the "Create another Post" checkbox should not be checked

  Scenario: Application config of true and a resource config of false
    Given a configuration of:
    """
      ActiveAdmin.application.create_another = true
      ActiveAdmin.register Post do
        config.create_another = false
      end
    """
    When I am on the new post page
    Then I should not see the element ".create_another"
