@javascript
Feature: Has Many

  A resource has many other resources

  Background:
    Given I am logged in
    And a post with the title "Hello World" written by "John Doe" exists

  Scenario: Updating the parent resource page with default text for Remove button
    Given a configuration of:
    """
      ActiveAdmin.register User do
        form do |f|
          f.inputs do
            f.has_many :posts do |ff|
              ff.input :title
              ff.input :body
            end
          end
          f.actions
        end
      end
      ActiveAdmin.register Post
    """
    When I go to the last author's show page
    And I follow "Edit User"
    Then I should see a link to "Add New Post"

    When I click "Add New Post"
    Then I should see a link to "Remove"

  Scenario: Updating the parent resource page with custom text for Remove button
    Given a configuration of:
    """
      ActiveAdmin.register User do
        form do |f|
          f.inputs do
            f.has_many :posts, remove_record: "Hide" do |ff|
              ff.input :title
              ff.input :body
            end
          end
          f.actions
        end
      end
      ActiveAdmin.register Post
    """
    When I go to the last author's show page
    And I follow "Edit User"
    Then I should see a link to "Add New Post"

    When I click "Add New Post"
    Then I should see a link to "Hide"
