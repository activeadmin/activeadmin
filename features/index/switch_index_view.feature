Feature: Switch Index View

  In order to switch index views
  As a user
  I want to view links to views

  Scenario: Show default Page Presenter
    Given a post with the title "Hello World from Table" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index do
          column :title
        end
        index as: CustomIndexView do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
      end
      """
    Then I should see "Hello World from Table" within ".index-as-table"

  Scenario: Show links to different page views
    Given a post with the title "Hello World from Table" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index as: CustomIndexView do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
        index default: true do
          column :title
        end
      end
      """
    Then I should see "Hello World from Table" within ".index-as-table"
    And I should see a link to "Table"
    And I should see a link to "Custom"

  # Scenario: Show change between page views
  #   Given a post with the title "Hey from Table" and body "My body is awesome" exists
  #   And an index configuration of:
  #     """
  #     ActiveAdmin.register Post do
  #       index as: CustomIndexView do |post|
  #         span(link_to(post.title, admin_post_path(post)))
  #       end
  #       index default: true do
  #         column :title
  #         column :body
  #       end
  #     end
  #     """
  #   Then I should see "My body is awesome" within ".index-as-table"
  #   When I follow "Custom"
  #   Then I should not see "My body is awesome" within ".custom-index-view"
