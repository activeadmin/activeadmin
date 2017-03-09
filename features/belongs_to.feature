Feature: Belongs To

  A resource belongs to another resource

  Background:
    Given I am logged in
    And a post with the title "Hello World" written by "John Doe" exists
    And a post with the title "Hello World" written by "Jane Doe" exists

  Scenario: Viewing the child resource index page
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
      end
    """
    When I go to the last author's posts
    Then the "Users" tab should be selected
    And I should not see a menu item for "Posts"
    And I should see "Displaying 1 Post"
    And I should see a link to "Users" in the breadcrumb
    And I should see a link to "Jane Doe" in the breadcrumb

  Scenario: Updating a child resource page
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
        permit_params :title, :body, :published_date

        form do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    """
    When I go to the last author's last post page
    Then I follow "Edit Post"
    Then I should see the element "form[action='/admin/users/2/posts/2']"
    Then I should see a link to "Hello World" in the breadcrumb

    When I press "Update Post"
    Then I should see "Post was successfully updated."

  Scenario: Creating a child resource page
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
        permit_params :title, :body, :published_date

        form do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    """
    When I go to the last author's posts
    Then I follow "New Post"
    Then I should see the element "form[action='/admin/users/2/posts']"
    Then I fill in "Title" with "Hello World"
    Then I fill in "Body" with "This is the body"

    When I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"
    And I should see the attribute "Author" with "Jane Doe"

  Scenario: Viewing a child resource page
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
      end
    """
    When I go to the last author's posts
    And I follow "View"
    Then I should be on the last author's last post page
    And the "Users" tab should be selected

  Scenario: When the belongs to is optional
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user, optional: true
      end
    """
    When I go to the last author's posts
    Then the "Users" tab should be selected
    And I should see a menu item for "Posts"

    When I follow "Posts"
    Then the "Posts" tab should be selected

  Scenario: Displaying belongs to resources in main menu
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
        navigation_menu :user
      end
    """
    When I go to the last author's posts
    And I follow "View"
    Then the "Posts" tab should be selected
