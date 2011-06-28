Feature: Index as Grid

  Viewing resources as a grid on the index page

  Scenario: Viewing index as a grid with a simple block configuration
    Given 9 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :grid do |post|
          h2 auto_link(post)
        end
      end
      """
    Then the table ".index_grid" should have 3 rows
    And the table ".index_grid" should have 3 columns
    And there should be 9 "a" tags within index grid

  Scenario: Viewing index as a grid and set the number of columns
    Given 9 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
      index :as => :grid, :columns => 1 do |post|
          h2 auto_link(post)
        end
      end
      """
    Then the table ".index_grid" should have 9 rows
    And the table ".index_grid" should have 1 columns
    And there should be 9 "a" tags within "table.index_grid"

  Scenario: Viewing index as a grid with an odd number of items
    Given 9 posts exist
    And an index configuration of:
      """
      ActiveAdmin.register Post do
      index :as => :grid, :columns => 2 do |post|
          h2 auto_link(post)
        end
      end
      """
    Then the table ".index_grid" should have 5 rows
    And the table ".index_grid" should have 2 columns
    And there should be 9 "a" tags within "table.index_grid"
