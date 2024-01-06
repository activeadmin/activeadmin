Feature: Index Blank Slate

  Viewing an index page with no resources yet

  Scenario: Viewing the default table with no resources
    Given an index configuration of:
      """
        ActiveAdmin.register Post do
          batch_action :favourite do
            # nothing
          end
          scope :all, default: true
        end
      """
    Then I should not see a sortable table header
    And I should see "There are no Posts yet."
    And I should see "Create one"
    And I should not see ".data-table"
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

  Scenario: Customizing the default table with no resources
    Given an index configuration of:
      """
        ActiveAdmin.register Post do
          index blank_slate_link: ->{link_to("Go to dashboard", admin_root_path)} do |post|
          end
        end
      """
    When I follow "Go to dashboard"
    Then I should see "Dashboard"

  Scenario: Customizing the default table with no blank slate link
    Given an index configuration of:
      """
        ActiveAdmin.register Post do
          index blank_slate_link: false do |post|
          end
        end
      """
    Then I should see "There are no Posts yet."
    And I should not see "Create one"
