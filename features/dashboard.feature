Feature: Dashboard

  Scenario: With default configuration
    Given a configuration of:
      """
      ActiveAdmin.register_page "Dashboard" do
        content do
          para "Hello world from the dashboard page"
        end
      end
      """
    And I am logged in
    When I go to the dashboard
    Then I should not see the default welcome message
    And I should see "Hello world from the dashboard page"
