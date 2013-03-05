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

  Scenario: Viewing index when download_links disabled globally
    Given a configuration of:
      """
      ActiveAdmin.application.download_links = false
      """
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :table
      end
      """
    Given 1 posts exist
    When I am on the index page for posts
    Then I should be on the index page for posts
    Then I should not see a link to download "CSV"
    Given a configuration of:
      """
      ActiveAdmin.application.download_links = true
      """

  Scenario: Viewing index when download_links disabled only in one namespace
    Given a configuration of:
      """
      ActiveAdmin.setup do |config|
        config.namespace :superadmin do |namespace|
          namespace.download_links = false
        end
      end
      """
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :table
      end
      ActiveAdmin.register Post, :namespace => :superadmin do
        index :as => :table
      end
      """
    Given 1 posts exist
    When I am on the index page for posts in the superadmin namespace
    Then I should be on the index page for posts in the superadmin namespace
    Then I should not see a link to download "CSV"
    When I am on the index page for posts
    Then I should be on the index page for posts
    Then I should see a link to download "CSV"

  Scenario: Viewing index when download_links enabled only for a resource
    Given a configuration of:
      """
      ActiveAdmin.setup do |config|
        config.namespace :superadmin do |namespace|
          namespace.download_links = false
        end
      end
      """
    Given an index configuration of:
      """
      ActiveAdmin.register Post do
        index :as => :table
      end
      ActiveAdmin.register Post, :namespace => :superadmin do
        index :as => :table, :download_links => true
      end
      """
    Given 1 posts exist
    When I am on the index page for posts in the superadmin namespace
    Then I should be on the index page for posts in the superadmin namespace
    Then I should see a link to download "CSV"
