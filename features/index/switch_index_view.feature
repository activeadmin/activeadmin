Feature: Switch Index View

  In order to switch index views
  As a user
  I want to view links to views

  Scenario: Show default Page Presenter
  Given a post with the title "Hello World from Table" exists
  And an index configuration of:
    """
    ActiveAdmin.register Post do
      index :as => :table do
        column :title
      end
      index :as => :block do |post|
        span(link_to(post.title, admin_post_path(post)))
      end
    end
    """
  Then I should see "Hello World from Table" within ".index_as_table"

  Scenario: Show default Page Presenter when default is specified
    Given a post with the title "Hello World from Table" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :block do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
        index :as => :table, :default => true do
          column :title
        end
      end
      """
    Then I should see "Hello World from Table" within ".index_as_table"

  Scenario: Show links to different page views
    Given a post with the title "Hello World from Table" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :block do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
        index :as => :table, :default => true do
          column :title
        end
      end
      """
    Then I should see "Hello World from Table" within ".index_as_table"
    And I should see a link to "Table"
    And I should see a link to "List"

  Scenario: Show change between page views
    Given a post with the title "Hey from Table" and body "My body is awesome" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :block do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
        index :as => :table, :default => true do
          column :title
          column :body
        end
      end
      """
    Then I should see "My body is awesome" within ".index_as_table"
    When I click "List"
    Then I should not see "My body is awesome" within ".index_as_block"



