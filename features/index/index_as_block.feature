Feature: Index as Block

  Viewing the resource as a block which is renderered by the user

  Scenario: Viewing the index as a block
    Given a post with the title "Hello World from Block" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :block do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
      end
      """
    Then I should see "Hello World from Block" within ".index_as_block"
