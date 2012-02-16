Feature: Index Parameters

  Scenario: Viewing index when download_links disabled
    Given an index configuration of:
    """
    ActiveAdmin.register Post do
      index :as => :table, :download_links => false
    end
    """
    Given 31 posts exist
    When I am on the index page for posts
    Then I should not see a link to download "CSV"
