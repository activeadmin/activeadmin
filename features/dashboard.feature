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
    Given I am logged in
    When I go to the dashboard
    Then I should see the Active Admin layout
    And I should not see the default welcome message
    And I should see "Hello world from the dashboard page"
