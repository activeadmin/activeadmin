Feature: Index Scoping

  Viewing resources and scoping them

  Scenario: Viewing resources with one scope and no default
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all
      end
      """
    Then I should see the scope "All" not selected
    And I should see the scope "All" with the count 10
    And I should see 10 posts in the table

  Scenario: Viewing resources with one scope as the default
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, :default => true
      end
      """
    Then I should see the scope "All" selected
    And I should see the scope "All" with the count 10
    And I should see 10 posts in the table

  Scenario: Viewing resources with one scope and no results
    Given 10 posts exist
    And an index configuration of:
     """
     ActiveAdmin.register Post do
       scope :all, :default => true
       filter :title
     end
     """

    When I fill in "Search Title" with "Hello World 17"
    And I press "Filter"
    And I should not see the scope "All"

    When I am on the index page for posts
    Then I should see the scope "All" selected

  Scenario: Viewing resources with a scope but scope_count turned off
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, :default => true
        index :as => :table, :scope_count => false
      end
      """
    Then I should see the scope "All" selected
    And I should see the scope "All" with no count
    And I should see 10 posts in the table

  @scope
  Scenario: Viewing resources with a scope and scope count turned off for a single scope
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, :default => true, :show_count => false
      end
      """
    Then I should see the scope "All" selected
    And I should see the scope "All" with no count
    And I should see 10 posts in the table

  Scenario: Viewing resources when scoping
    Given 6 posts exist
    And 4 published posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, :default => true
        scope :published do |posts|
          posts.where("published_at IS NOT NULL")
        end
      end
      """
    Then I should see the scope "All" with the count 10
    And I should see 10 posts in the table
    Then I should see the scope "Published" with the count 4
    When I follow "Published"
    Then I should see the scope "Published" selected
    And I should see 4 posts in the table

  Scenario: Viewing resources with optional scopes
    Given 10 posts exist
    And an index configuration of:
    """
    ActiveAdmin.register Post do
      scope :all, :if => proc { false }
      scope "Shown", :if => proc { true } do |posts|
        posts
      end
      scope "Default", :default => true do |posts|
        posts
      end
      scope 'Today', :if => proc { false } do |posts|
        posts.where(["created_at > ? AND created_at < ?", ::Time.zone.now.beginning_of_day, ::Time.zone.now.end_of_day])
      end
    end
    """
    Then I should see the scope "Default" selected
    And I should not see the scope "All"
    And I should not see the scope "Today"
    And I should see the scope "Shown"
    And I should see the scope "Default" with the count 10

  Scenario: Viewing resources with multiple scopes as blocks
    Given 10 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope 'Today', :default => true do |posts|
          posts.where(["created_at > ? AND created_at < ?", ::Time.zone.now.beginning_of_day, ::Time.zone.now.end_of_day])
        end
        scope 'Tomorrow' do |posts|
          posts.where(["created_at > ? AND created_at < ?", ::Time.zone.now.beginning_of_day + 1.day, ::Time.zone.now.end_of_day + 1.day])
        end
      end
      """
    Then I should see the scope "Today" selected
    And I should see the scope "Tomorrow" not selected
    And I should see the scope "Today" with the count 10
    And I should see the scope "Tomorrow" with the count 0
    And I should see 10 posts in the table
    And I should see a link to "Tomorrow"

    When I follow "Tomorrow"
    Then I should see the scope "Tomorrow" selected
    And I should see the scope "Today" not selected
    And I should see a link to "Today"
