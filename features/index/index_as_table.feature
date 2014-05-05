Feature: Index as Table

  Viewing resources as a table on the index page

  Scenario: Viewing the default table with one resources
    Given an index configuration of:
      """
        ActiveAdmin.register Post
      """
    And 1 post exists
    When I am on the index page for posts
    Then I should see a sortable table header with "Id"
    And I should see a sortable table header with "Title"
    And I should see a table with id "index_table_posts"

  Scenario: Viewing the default table with a resource
    Given a post with the title "Hello World" exists
    And an index configuration of:
      """
        ActiveAdmin.register Post
      """
    Then I should see "Hello World"
    Then I should see nicely formatted datetimes
    And I should see a link to "View"
    And I should see a link to "Edit"
    And I should see a link to "Delete"

  Scenario: Customizing the columns with symbols
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index do
          column :title
          column :body
        end
      end
      """
    Then I should see a sortable table header with "Title"
    And I should see a sortable table header with "Body"
    And I should see "Hello World"
    And I should see "From the body"

  Scenario: Customizing the columns with a block
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index do
          column("My Title") do |post|
            post.title
          end
          column("My Body") do |post|
            post.body
          end
        end
      end
      """
    Then I should see a table header with "My Title"
    And I should see a table header with "My Body"
    And I should see "Hello World"
    And I should see "From the body"

  Scenario: Showing and Hiding columns
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index do
          if current_active_admin_user
            column :title
          end
          if current_active_admin_user.nil?
            column :body
          end
        end
      end
      """
    Then I should see a sortable table header with "Title"
    And I should not see a table header with "Body"
    And I should see "Hello World"
    And I should not see "From the body"

  Scenario: Default Actions
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        actions :index, :show, :edit, :update
      end
      """
    Then I should see a member link to "View"
    And I should see a member link to "Edit"
    And I should not see a member link to "Delete"

  Scenario: Actions with custom column options
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index do
          column :category
          actions class: 'custom-column-class', name: 'That text'
        end
      end
      """
    Then I should see the actions column with the class "custom-column-class" and the title "That text"

  Scenario: Actions with defaults and custom actions
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        actions :index, :show, :edit, :update

        index do
          column :category
          actions do |resource|
            link_to 'Custom Action', edit_admin_post_path(resource), :class => 'member_link'
          end
        end
      end
      """
    Then I should see a member link to "View"
    And I should see a member link to "Edit"
    And I should not see a member link to "Delete"
    And I should see a member link to "Custom Action"

  Scenario: Actions without default actions
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        actions :index, :show, :edit, :update

        index do
          column :category
          actions :defaults => false do |resource|
            link_to 'Custom Action', edit_admin_post_path(resource), :class => 'member_link'
          end
        end
      end
      """
    Then I should not see a member link to "View"
    And I should not see a member link to "Edit"
    And I should not see a member link to "Delete"
    And I should see a member link to "Custom Action"

  Scenario: Actions with defaults and custom actions within a dropdown
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        actions :index, :show, :edit, :update

        index do
          column :category
          actions dropdown: true do |resource|
            item 'Custom Action', edit_admin_post_path(resource)
          end
        end
      end
      """
    Then I should see a dropdown menu item to "View"
    And I should see a dropdown menu item to "Edit"
    And I should not see a dropdown menu item to "Delete"
    And I should see a dropdown menu item to "Custom Action"

  Scenario: Actions without default actions within a dropdown
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        actions :index, :show, :edit, :update

        index do
          column :category
          actions :defaults => false, dropdown: true do |resource|
            item 'Custom Action', edit_admin_post_path(resource)
          end
        end
      end
      """
    Then I should not see a dropdown menu item to "View"
    And I should not see a dropdown menu item to "Edit"
    And I should not see a dropdown menu item to "Delete"
    And I should see a dropdown menu item to "Custom Action"

  Scenario: Index page without show action
    Given a post with the title "Hello World" and body "From the body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        actions :index
      end
      """
    Then I should not see a member link to "View"
    And I should not see a member link to "Edit"
    And I should not see a member link to "Delete"
    And I should see "Hello World"

  Scenario: Associations are not sortable
    Given 1 post exists
    And an index configuration of:
      """
        ActiveAdmin.register Post do
          index do
            column :category
          end
        end
      """
    Then I should not see a sortable table header with "Category"

  Scenario: Sorting
    Given a post with the title "Hello World" and body "From the body" exists
    And a post with the title "Bye bye world" and body "Move your..." exists
    And an index configuration of:
      """
      ActiveAdmin.register Post
      """
    When I am on the index page for posts
    Then I should see the "index_table_posts" table:
      | [ ] | Id | Title        | Body | Published At | Position | Starred | Created At | Updated At | |
      | [ ] | 2 | Bye bye world | Move your...  |  |  | No | /.*/ | /.*/ | ViewEditDelete |
      | [ ] | 1 | Hello World   | From the body |  |  | No | /.*/ | /.*/ | ViewEditDelete |
    When I follow "Id"
    Then I should see the "index_table_posts" table:
      | [ ] | Id | Title        | Body | Published At | Position | Starred | Created At | Updated At | |
      | [ ] | 1 | Hello World   | From the body |  |  | No | /.*/ | /.*/ | ViewEditDelete |
      | [ ] | 2 | Bye bye world | Move your...  |  |  | No | /.*/ | /.*/ | ViewEditDelete |

  Scenario: Sorting by a virtual column
    Given a post with the title "Hello World" exists
    And a post with the title "Bye bye world" exists
    And an index configuration of:
      """
        ActiveAdmin.register Post do
          controller do
            def scoped_collection
              Post.select("id, title, length(title) as title_length")
            end
          end

          index do
            column :id
            column :title
            column("Title Length", :sortable => :title_length) { |post| post.title_length }
          end
        end
      """
    When I am on the index page for posts
    And I follow "Title Length"
    Then I should see the "index_table_posts" table:
      | Id | Title        | Title Length |
      | 2 | Bye bye world | 13 |
      | 1 | Hello World   | 11 |
    When I follow "Title Length"
    Then I should see the "index_table_posts" table:
      | Id | Title        | Title Length |
      | 1 | Hello World   | 11 |
      | 2 | Bye bye world | 13 |
