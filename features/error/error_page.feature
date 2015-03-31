Feature: Error Page

  Scenario: For a 500 Error Page
    Given a configuration of:
    """
      ActiveAdmin.register_page "Dashboard" do
        content do
          five_hundred_error
        end
      end
      """
    Given I am logged in
    When I go to the dashboard
    Then I should see the Active Admin layout
    And I should see the page title "Error 500"

  Scenario: For a 404 Error Page
    Given an index configuration of:
    """
        ActiveAdmin.register Post
      """
    When I visit "/admin/posts/1"
    Then I should see the Active Admin layout
    And I should see the page title "Error 404"
