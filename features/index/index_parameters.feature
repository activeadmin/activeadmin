Feature: Index Parameters

  Scenario: Viewing index when download_links disabled
    Given an index configuration of:
    """
    ActiveAdmin.register Post do
      index as: :table, download_links: false
    end
    """
    And 31 posts exist
    When I am on the index page for posts
    Then I should not see a link to download "CSV"

  Scenario: Viewing index when download_links disabled globally
    Given a configuration of:
      """
      ActiveAdmin.application.download_links = false
      """
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index as: :table
      end
      """
    And 1 posts exist
    When I am on the index page for posts
    Then I should be on the index page for posts
    And I should not see a link to download "CSV"
    Given a configuration of:
      """
      ActiveAdmin.application.download_links = true
      """

  Scenario: Viewing index when download_links disabled only in one namespace
    Given a configuration of:
      """
      ActiveAdmin.application.namespace(:superadmin).download_links = false
      ActiveAdmin.register AdminUser, namespace: :superadmin
      """
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index as: :table
      end
      ActiveAdmin.register Post, namespace: :superadmin do
        index as: :table
      end
      """
    And 1 posts exist
    When I am on the index page for posts in the superadmin namespace
    Then I should be on the index page for posts in the superadmin namespace
    And I should not see a link to download "CSV"
    When I am on the index page for posts
    Then I should be on the index page for posts
    And I should see a link to download "CSV"

  Scenario: Viewing index when download_links enabled only for a resource
    Given a configuration of:
      """
      ActiveAdmin.application.namespace(:superadmin).download_links = false
      ActiveAdmin.register AdminUser, namespace: :superadmin
      """
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index as: :table
      end
      ActiveAdmin.register Post, namespace: :superadmin do
        index as: :table, download_links: true
      end
      """
    And 1 posts exist
    When I am on the index page for posts in the superadmin namespace
    Then I should be on the index page for posts in the superadmin namespace
    And I should see a link to download "CSV"
