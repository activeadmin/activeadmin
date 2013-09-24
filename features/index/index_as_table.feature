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

  Scenario: Associations are not sortable by default
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

  Scenario: Sorting by associated columns
    Given a post with the title "A history of time" written by "Stephen Hawking" exists
    And a post with the title "On uncertainity" written by "Werner Heisenberg" exists
    And a post with the title "Renormalization" written by "Richard Feynman" exists
    And a post with the title "Quantum Loop Gravity" written by "Carlo Rovelli" exists
    And an index configuration of:
      """
        ActiveAdmin.register Post do
          config.sort_order = 'id_asc'
          index do
            column :id
            column :title
            column :author, :sortable => 'author_first_name' do |post|
              [post.author.first_name, post.author.last_name].join(' ')
            end
            column :citation, :sortable => 'author_last_name_and_title' do |post|
              "%s, %s.: %s" % [post.author.last_name, post.author.first_name[0], post.title]
            end
          end
        end
      """
    When I am on the index page for posts
    Then I should see the "index_table_posts" table:
      | Id | Title                | Author            | Citation                          |
      | 1  | A history of time    | Stephen Hawking   | Hawking, S.: A history of time    |
      | 2  | On uncertainity      | Werner Heisenberg | Heisenberg, W.: On uncertainity   |
      | 3  | Renormalization      | Richard Feynman   | Feynman, R.: Renormalization      |
      | 4  | Quantum Loop Gravity | Carlo Rovelli     | Rovelli, C.: Quantum Loop Gravity |
    When I follow "Author"
    Then I should see the "index_table_posts" table:
      | Id | Title                | Author            | Citation                          |
      | 2  | On uncertainity      | Werner Heisenberg | Heisenberg, W.: On uncertainity   |
      | 1  | A history of time    | Stephen Hawking   | Hawking, S.: A history of time    |
      | 3  | Renormalization      | Richard Feynman   | Feynman, R.: Renormalization      |
      | 4  | Quantum Loop Gravity | Carlo Rovelli     | Rovelli, C.: Quantum Loop Gravity |
    When I follow "Author"
    Then I should see the "index_table_posts" table:
      | Id | Title                | Author            | Citation                          |
      | 4  | Quantum Loop Gravity | Carlo Rovelli     | Rovelli, C.: Quantum Loop Gravity |
      | 3  | Renormalization      | Richard Feynman   | Feynman, R.: Renormalization      |
      | 1  | A history of time    | Stephen Hawking   | Hawking, S.: A history of time    |
      | 2  | On uncertainity      | Werner Heisenberg | Heisenberg, W.: On uncertainity   |
    When I follow "Citation"
    Then I should see the "index_table_posts" table:
      | Id | Title                | Author            | Citation                          |
      | 4  | Quantum Loop Gravity | Carlo Rovelli     | Rovelli, C.: Quantum Loop Gravity |
      | 2  | On uncertainity      | Werner Heisenberg | Heisenberg, W.: On uncertainity   |
      | 1  | A history of time    | Stephen Hawking   | Hawking, S.: A history of time    |
      | 3  | Renormalization      | Richard Feynman   | Feynman, R.: Renormalization      |
    When I follow "Citation"
    Then I should see the "index_table_posts" table:
      | Id | Title                | Author            | Citation                          |
      | 3  | Renormalization      | Richard Feynman   | Feynman, R.: Renormalization      |
      | 1  | A history of time    | Stephen Hawking   | Hawking, S.: A history of time    |
      | 2  | On uncertainity      | Werner Heisenberg | Heisenberg, W.: On uncertainity   |
      | 4  | Quantum Loop Gravity | Carlo Rovelli     | Rovelli, C.: Quantum Loop Gravity |

  Scenario: Sorting
    Given a post with the title "Hello World" and body "From the body" exists
    And a post with the title "Bye bye world" and body "Move your..." exists
    And an index configuration of:
      """
      ActiveAdmin.register Post
      """
    When I am on the index page for posts
    Then I should see the "index_table_posts" table:
      | [ ] | Id | Title        | Body | Published At | Starred | Created At | Updated At | |
      | [ ] | 2 | Bye bye world | Move your...  |  |  | /.*/ | /.*/ | ViewEditDelete |
      | [ ] | 1 | Hello World   | From the body |  |  | /.*/ | /.*/ | ViewEditDelete |
    When I follow "Id"
    Then I should see the "index_table_posts" table:
      | [ ] | Id | Title        | Body | Published At | Starred | Created At | Updated At | |
      | [ ] | 1 | Hello World   | From the body |  |  | /.*/ | /.*/ | ViewEditDelete |
      | [ ] | 2 | Bye bye world | Move your...  |  |  | /.*/ | /.*/ | ViewEditDelete |

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
