@filters
Feature: Index Filtering

  Scenario: Default Resources Filters
    Given 3 posts exist
    And an index configuration of:
    """
      ActiveAdmin.register Post
    """
    When I am on the index page for posts
    Then I should see "Showing all 3"
    And I should see the following filters:
     | Author         | select     |
     | Category       | select     |
     | Title          | string     |
     | Body           | string     |
     | Published date | date range |
     | Created at     | date range |
     | Updated at     | date range |

    When I fill in "Title" with "Hello World 2"
    And I press "Filter"
    And I should see 1 posts in the table
    And I should see "Hello World 2" in the table
    And I should see current filter "title_cont" equal to "Hello World 2" with label "Title contains"

  Scenario: No XSS in Resources Filters
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        filter :title
      end
    """
    When I fill in "Title" with "<script>alert('hack')</script>"
    And I press "Filter"
    Then I should see current filter "title_cont" equal to "<script>alert('hack')</script>" with label "Title contains"

  Scenario: Filtering posts with no results
    Given 3 posts exist
    And an index configuration of:
    """
      ActiveAdmin.register Post
    """
    When I am on the index page for posts
    Then I should see "Showing all 3"

    When I fill in "Title" with "THIS IS NOT AN EXISTING TITLE!!"
    And I press "Filter"
    Then I should not see ".data-table"
    And I should not see a sortable table header
    And I should not see pagination
    And I should see "No Posts found"

  Scenario: Filtering posts with pagination
    Given 7 posts with the title "Hello World 3" exist
    And 1 post with the title "Hello World 4" exist
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 2
      end
    """
    When I fill in "Title" with "Hello World 3"
    And I press "Filter"

    Then I follow "2"
    And I should see "Showing 3-4 of 7"

    And I follow "3"
    And I should see "Showing 5-6 of 7"

  Scenario: Filtering posts while not on the first page
    Given 9 posts exist
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        config.per_page = 5
      end
    """
    When I follow "2"
    Then I should see "Showing 6-9 of 9"

    When I fill in "Title" with "Hello World 2"
    And I press "Filter"
    Then I should see 1 posts in the table
    And I should see "Hello World 2" in the table

  Scenario: Checkboxes - Filtering posts written by anyone
    Given 1 post exists
    And a post with the title "Hello World" written by "Jane Doe" exists
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        filter :author, as: :check_boxes
      end
    """
    When I press "Filter"
    Then I should see 2 posts in the table
    And I should see "Hello World" in the table
    And the "Jane Doe" checkbox should not be checked

  Scenario: Checkboxes - Filtering posts written by Jane Doe
    Given 1 post exists
    And a post with the title "Hello World" written by "Jane Doe" exists
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        filter :author, as: :check_boxes
      end
    """
    When I check "Jane Doe"
    And I press "Filter"
    Then I should see 1 posts in the table
    And I should see "Hello World" in the table
    And the "Jane Doe" checkbox should be checked
    And I should see current filter "author_id_in" equal to "Jane Doe"

  Scenario: Disabling filters
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        config.filters = false
      end
    """
    Then I should not see "Filters"

  Scenario: Select - Filtering categories with posts written by Jane Doe
    Given a category named "Mystery" exists
    And 1 post with the title "Hello World" written by "Jane Doe" in category "Non-Fiction" exists
    And an index configuration of:
    """
      ActiveAdmin.register Category
    """
    When I select "Jane Doe" from "Authors"
    And I press "Filter"
    Then I should see 1 categories in the table
    And I should see "Non-Fiction" in the table
    And I should not see "Mystery" in the table
    And I should see current filter "posts_author_id_eq" equal to "Jane Doe"

  @javascript
  Scenario: Clearing filters preserves custom parameters
    Given a category named "Mystery" exists
    And 1 post with the title "Hello World" written by "Jane Doe" in category "Non-Fiction" exists
    And 1 post with the title "Lorem Ipsum" written by "Joe Smith" in category "Mystery" exists
    And an index configuration of:
    """
    ActiveAdmin.register Category
    """
    Then I should see "Showing all 2"
    When I add parameter "scope" with value "all" to the URL
    And I add parameter "foo" with value "bar" to the URL
    And I select "Hello World" from "Posts"
    And I press "Filter"
    Then I should see "Non-Fiction"
    And I should not see "Mystery"
    When I click "Clear Filters"
    Then I should see "Non-Fiction"
    And I should see "Mystery"
    And I should have parameter "foo" with value "bar"
    And I should have parameter "scope" with value "all"

  Scenario: Checkboxes - Filtering categories via posts written by anyone
    Given a category named "Mystery" exists
    And a post with the title "Hello World" written by "Jane Doe" in category "Non-Fiction" exists
    And an index configuration of:
    """
      ActiveAdmin.register Category do
        filter :authors, as: :check_boxes
      end
    """
    When I press "Filter"
    Then I should see 2 posts in the table
    And I should see "Mystery" in the table
    And I should see "Non-Fiction" in the table
    And the "Jane Doe" checkbox should not be checked
    And I should not see "Active Search"

  Scenario: Checkboxes - Filtering categories via posts written by Jane Doe
    Given a category named "Mystery" exists
    And a post with the title "Hello World" written by "Jane Doe" in category "Non-Fiction" exists
    And an index configuration of:
    """
      ActiveAdmin.register Category do
        filter :authors, as: :check_boxes
      end

    """
    When I check "Jane Doe"
    And I press "Filter"
    Then I should see 1 categories in the table
    And I should see "Non-Fiction" in the table
    And the "Jane Doe" checkbox should be checked

  Scenario: Filtering posts without default scope
    Given a post with the title "Hello World" written by "Jane Doe" exists
    And an index configuration of:
    """
      ActiveAdmin.register Post do
        scope :all
        scope :published do |posts|
          posts.where("published_date IS NOT NULL")
        end

        filter :title
      end
    """
    When I fill in "Title" with "Hello"
    And I press "Filter"
    Then I should see current filter "title_cont" equal to "Hello" with label "Title contains"

  Scenario: Filtering posts by category
    Given a category named "Mystery" exists
    And a post with the title "Hello World" written by "Jane Doe" in category "Non-Fiction" exists
    And an index configuration of:
    """
      ActiveAdmin.register Category
      ActiveAdmin.register Post do
         filter :category
      end
    """
    And I am on the index page for posts

    When I select "Non-Fiction" from "Category"
    And I press "Filter"
    Then I should see "Active Search"
    And I should see link "Non-Fiction" in current filters

  Scenario: Enabling filters status sidebar
    Given an index configuration of:
    """
      ActiveAdmin.application.current_filters = false
      ActiveAdmin.register Post do
        config.current_filters = true
      end
    """
    And I press "Filter"
    Then I should see "Active Search"

  Scenario: Disabling filters status sidebar
    Given an index configuration of:
    """
      ActiveAdmin.application.current_filters = true
      ActiveAdmin.register Post do
        config.current_filters = false
      end
    """
    And I press "Filter"
    Then I should not see "Active Search"

  Scenario: Filters and nested resources
    Given a post with the title "The arrogant president" written by "Jane Doe" exists
    And a configuration of:
    """
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        permit_params :user_id

        belongs_to :author, class_name: "User"
      end
    """
    And I am logged in
    And I am on the index page for users
    When I select "The arrogant president" from "Posts"
    And I press "Filter"
    And I should see 1 user in the table

  Scenario: Too many categories to show
    Given a category named "Astrology" exists
    And a category named "Astronomy" exists
    And a category named "Navigation" exists
    And a post with the title "Star Signs" in category "Astrology" exists
    And a post with the title "Constellations" in category "Astronomy" exists
    And a post with the title "Compass and Sextant" in category "Navigation" exists
    And an index configuration of:
    """
      ActiveAdmin.register Category
      ActiveAdmin.register Post do
        config.namespace.maximum_association_filter_arity = 3
      end
    """
    And I am on the index page for posts
    Then I should see "Category" within "#filters_sidebar_section label[for="q_custom_category_id"]"
    And I should not see "Category name starts with" within "#filters_sidebar_section"

    Given an index configuration of:
    """
      ActiveAdmin.register Category
      ActiveAdmin.register Post do
        config.namespace.maximum_association_filter_arity = 2
      end
    """
    And I am on the index page for posts
    Then I should see "Category name start" within "#filters_sidebar_section"
    When I fill in "Category name start" with "Astro"
    And I press "Filter"
    Then I should see "Star Signs"
    And I should see "Constellations"
    And I should not see "Compass and Sextant"

    Given an index configuration of:
    """
      ActiveAdmin.register Category
      ActiveAdmin.register Post do
        config.namespace.maximum_association_filter_arity = 2
        config.namespace.filter_method_for_large_association = '_cont'
      end
    """
    And I am on the index page for posts
    Then I should see "Category name cont" within "#filters_sidebar_section"
    When I fill in "Category name cont" with "Astro"
    And I press "Filter"
    Then I should see "Star Signs"
    And I should see "Constellations"
    And I should not see "Compass and Sextant"

    Given an index configuration of:
    """
      ActiveAdmin.register Category
      ActiveAdmin.register Post do
        config.namespace.maximum_association_filter_arity = :unlimited
        config.namespace.filter_method_for_large_association = '_cont'
      end
    """
    And I am on the index page for posts
    Then I should see "Category" within "#filters_sidebar_section"
    When I select "Astronomy" from "Category"
    And I press "Filter"
    Then I should not see "Star Signs"
    And I should see "Constellations"
    And I should not see "Compass and Sextant"

    Given an index configuration of:
    """
      ActiveAdmin.register Category
      ActiveAdmin.register Post do
        config.namespace.maximum_association_filter_arity = :unlimited
      end
    """
    And I am on the index page for posts
    Then I should see "Category" within "#filters_sidebar_section label[for="q_custom_category_id"]"
    And I should not see "Category name starts with" within "#filters_sidebar_section"

  Scenario: Custom ransackable scopes filters
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        filter :fancy_filter, label: "Ransackable Custom Filter", as: :select, collection: ["Starred", "Not Starred"]
      end
    """
    And 1 unstarred post with the title "Hello World" written by "Jane Doe" exists
    When I select "Starred" from "Ransackable Custom Filter"
    And I press "Filter"
    Then I should see current filter "fancy_filter" equal to "Starred" with label "Ransackable Custom Filter"
    And I should not see "Hello World"
    When I select "Not Starred" from "Ransackable Custom Filter"
    And I press "Filter"
    Then I should see current filter "fancy_filter" equal to "Not Starred" with label "Ransackable Custom Filter"
    And I should see "Hello World"

  Scenario: "counter cache"-like filters
    Given a user named "Jane Doe" exists
    And an index configuration of:
    """
      ActiveAdmin.register User
    """
    When I am on the index page for users
    Then I should see "Showing 1 of 1"
    And I should see the following filters:
     | Sign in count  | number     |

    When I fill in "Sign in count" with "0"
    And I press "Filter"
    Then I should see 1 users in the table
    When I fill in "Sign in count" with "1"
    And I press "Filter"
    Then I should see "No Users found"
