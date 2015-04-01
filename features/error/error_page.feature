Feature: Error Page

  Background:
    Given I am logged in

  Scenario: For a 500 Error Page
    Given a configuration of:
      """
      ActiveAdmin.application.active_admin_error_page = true
      ActiveAdmin.register_page "Dashboard" do
        content do
          five_hundred_error
        end
      end
      """
    When I go to the dashboard
    Then I should see the Active Admin layout
    And I should see the page title "Error"

  Scenario: For a 404 Error Page
    Given an index configuration of:
      """
        ActiveAdmin.application.active_admin_error_page = true
        ActiveAdmin.register Post
      """
    When I visit "/admin/posts/1"
    Then I should see the Active Admin layout
    And I should see the page title "Error"
