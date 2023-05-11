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
        belongs_to :author, class_name: "User", param: "user_id", route_name: "user"
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
        belongs_to :author, class_name: "User", param: "user_id", route_name: "user"
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
    And I follow "Edit Post"
    Then I should see the element "form[action='/admin/users/2/posts/2']"
    And I should see a link to "Hello World" in the breadcrumb

    When I press "Update Post"
    Then I should see "Post was successfully updated."

  Scenario: Updating a child resource page with custom configuration
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :author, class_name: "User", param: "user_id", route_name: "user"
        permit_params :title

        form do |f|
          f.actions
        end
      end
    """
    When I go to the last author's last post page
    And I follow "Edit Post"
    Then I should see the element "form[action='/admin/users/2/posts/2']"
    And I should see a link to "Hello World" in the breadcrumb

    When I press "Update Post"
    Then I should see "Post was successfully updated."

  Scenario: Creating a child resource page
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :author, class_name: "User", param: "user_id", route_name: "user"
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
    And I follow "New Post"
    Then I should see the element "form[action='/admin/users/2/posts']"
    When I fill in "Title" with "Hello World"
    And I fill in "Body" with "This is the body"

    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"
    And I should see the attribute "Author" with "Jane Doe"

  Scenario: Creating a child resource page when belongs to defined after permitted params
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        permit_params :title, :body, :published_date
        belongs_to :user

        form do |f|
          f.actions
        end
      end
    """
    When I go to the last author's posts
    And I follow "New Post"
    Then I should see the element "form[action='/admin/users/2/posts']"

  Scenario: Viewing a child resource page
    Given a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :author, class_name: "User", param: "user_id", route_name: "user"
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
        belongs_to :author, class_name: "User", param: "user_id", route_name: "user", optional: true
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
        belongs_to :author, class_name: "User", param: "user_id", route_name: "user"
        navigation_menu :user
      end
    """
    When I go to the last author's posts
    And I follow "View"
    Then the "Posts" tab should be selected
