Feature: Index Blank Slate

  Viewing an index page with no resources yet

  Scenario: Viewing the default table with no resources
    Given an index configuration of:
      """
        ActiveAdmin.register Post do
          batch_action :favourite do
            # nothing
          end
          scope :all, :default => true
        end
      """
    Then I should not see a sortable table header
    And I should see "There are no Posts yet. Create one"
    And I should not see ".index_table"
    And I should not see pagination
    When I follow "Create one"
    Then I should be on the new post page

  Scenario: Viewing the default table with no resources and no 'new' action
    Given an index configuration of:
      """
        ActiveAdmin.register Post do
          actions :index, :show
        end
      """
    And I should see "There are no Posts yet."
    And I should not see "Create one"
  
  Scenario: Viewing a index using a grid with no resources
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :grid do |post|
          h2 auto_link(post)
        end
      end
      """
    And I should see "There are no Posts yet. Create one"
    
  Scenario: Viewing a index using blocks with no resources
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :block do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
      end
      """
    And I should see "There are no Posts yet. Create one"
    
  Scenario: Viewing a blog with no resources
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :blog
      end
      """
    And I should see "There are no Posts yet. Create one"
