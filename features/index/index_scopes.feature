Feature: Index Scoping

  Viewing resources and scoping them

  Scenario: Viewing resources with one scope and no default
    Given 3 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all
      end
      """
    Then I should see the scope "All" not selected
    And I should see the scope "All" with the count 3
    And I should see 3 posts in the table

  Scenario: Viewing resources with one scope with dynamic name
    Given 3 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope -> { scope_title }, :all

        controller do
          def scope_title
            'Neat scope'
          end

          helper_method :scope_title
        end
      end
      """
    Then I should see the scope with label "Neat scope"
    And I should see 3 posts in the table
    When I follow "Neat scope"
    And I should see 3 posts in the table
    And I should see the current scope with label "Neat scope"

  Scenario: Viewing resources with one scope as the default
    Given 3 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, default: true
      end
      """
    Then I should see the scope "All" selected
    And I should see the scope "All" with the count 3
    And I should see 3 posts in the table

  Scenario: Viewing resources with one scope that is set as not default
    Given 3 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, default: proc{ false }
      end
      """
    Then I should see the scope "All" not selected
    And I should see the scope "All" with the count 3
    And I should see 3 posts in the table

  Scenario: Viewing resources with a scope and no results
    Given 3 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, default: true
        filter :title
      end
      """
    When I fill in "Title" with "Non Existing Post"
    And I press "Filter"
    Then I should see the scope "All" selected


  Scenario: Viewing resources with a scope but scope_count turned off
    Given 3 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, default: true
        index as: :table, scope_count: false
      end
      """
    Then I should see the scope "All" selected
    And I should see the scope "All" with no count
    And I should see 3 posts in the table

  @scope
  Scenario: Viewing resources with a scope and scope count turned off for a single scope
    Given 3 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, default: true, show_count: false
      end
      """
    Then I should see the scope "All" selected
    And I should see the scope "All" with no count
    And I should see 3 posts in the table

  Scenario: Viewing resources when scoping
    Given 2 posts exist
    And 3 published posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, default: true
        scope :published do |posts|
          posts.where("published_date IS NOT NULL")
        end
      end
      """
    Then I should see the scope "All" with the count 5
    And I should see 5 posts in the table
    And I should see the scope "Published" with the count 3
    When I follow "Published"
    Then I should see the scope "Published" selected
    Then I should see the current scope with label "Published"
    And I should see 3 posts in the table

  Scenario: Viewing resources when scoping and filtering
    Given 2 posts written by "Daft Punk" exist
    Given 1 published posts written by "Daft Punk" exist

    Given 1 posts written by "Alfred" exist
    Given 2 published posts written by "Alfred" exist

    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, default: true
        scope :published do |posts|
          posts.where("published_date IS NOT NULL")
        end
      end
      """
    Then I should see the scope "All" with the count 6
    And I should see the scope "Published" with the count 3
    And I should see 6 posts in the table

    When I follow "Published"
    Then I should see the scope "Published" selected
    And I should see the current scope with label "Published"
    And I should see the scope "All" with the count 6
    And I should see the scope "Published" with the count 3
    And I should see 3 posts in the table

    When I select "Daft Punk" from "Author"
    And I press "Filter"

    Then I should see the scope "Published" selected
    And I should see the scope "All" with the count 3
    And I should see the scope "Published" with the count 1
    And I should see 1 posts in the table

  Scenario: Viewing resources with optional scopes
    Given 3 posts exist
    And an index configuration of:
    """
    ActiveAdmin.register Post do
      scope :all, if: proc { false }
      scope "Shown", if: proc { true } do |posts|
        posts
      end
      scope "Default", default: true do |posts|
        posts
      end
      scope 'Today', if: proc { false } do |posts|
        posts.where(["created_at > ? AND created_at < ?", ::Time.zone.now.beginning_of_day, ::Time.zone.now.end_of_day])
      end
    end
    """
    Then I should see the scope "Default" selected
    And I should not see the scope "All"
    And I should not see the scope "Today"
    And I should see the scope "Shown"
    And I should see the scope "Default" with the count 3

  Scenario: Viewing resources with multiple scopes as blocks
    Given 3 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope 'Today', default: true do |posts|
          posts.where(["created_at > ? AND created_at < ?", ::Time.zone.now.beginning_of_day, ::Time.zone.now.end_of_day])
        end
        scope 'Tomorrow' do |posts|
          posts.where(["created_at > ? AND created_at < ?", ::Time.zone.now.beginning_of_day + 1.day, ::Time.zone.now.end_of_day + 1.day])
        end
      end
      """
    Then I should see the scope "Today" selected
    And I should see the scope "Tomorrow" not selected
    And I should see the scope "Today" with the count 3
    And I should see the scope "Tomorrow" with the count 0
    And I should see 3 posts in the table
    And I should see a link to "Tomorrow"

    When I follow "Tomorrow"
    Then I should see the scope "Tomorrow" selected
    And I should see the scope "Today" not selected
    And I should see a link to "Today"
    And I should see the current scope with label "Tomorrow"

  Scenario: Viewing resources with scopes when scoping to user
    Given 2 posts written by "Daft Punk" exist
    And a post with the title "Monkey Wrench" written by "Foo Fighters" exists
    And a post with the title "Everlong" written by "Foo Fighters" exists
    And an index configuration of:
      """
        ActiveAdmin.register Post do
          scope_to :current_user
          scope :all, default: true

          filter :title

          controller do
            def current_user
              User.find_by_username('foo_fighters')
            end
          end
        end
      """
    Then I should see the scope "All" selected
    And I should see the scope "All" with the count 2
    When I fill in "Title" with "Monkey"
    And I press "Filter"
    Then I should see the scope "All" selected
    And I should see the scope "All" with the count 1

  Scenario: Viewing resources when scoping and filtering and group bys and stuff
    Given 2 posts written by "Daft Punk" exist
    Given 1 published posts written by "Daft Punk" exist

    Given 1 posts written by "Alfred" exist

    And an index configuration of:
      """
      ActiveAdmin.register Post do
        scope :all, default: true
        scope :published do |posts|
          posts.where("published_date IS NOT NULL")
        end
        scope :single do |posts|
           posts.page(1).per(1)
        end

        index do
          column :author_id
          column :count
        end

        config.sort_order = "author_id_asc"

        controller do
          def scoped_collection
            Post.select("author_id, count(*) as count").group("author_id")
          end
        end
      end
      """
    Then I should see the scope "All" with the count 2
    And I should see the scope "Published" with the count 1
    And I should see the scope "Single" with the count 1
    And I should see 2 posts in the table

    When I follow "Single"
    Then I should see 1 posts in the table

    When I follow "Published"
    Then I should see the scope "Published" selected
    And I should see the scope "All" with the count 2
    And I should see the scope "Published" with the count 1
    And I should see 1 posts in the table

    When I select "Daft Punk" from "Author"
    And I press "Filter"

    Then I should see the scope "Published" selected
    And I should see the scope "All" with the count 1
    And I should see the scope "Published" with the count 1
    And I should see 1 posts in the table
    And I should see the current scope with label "Published"
