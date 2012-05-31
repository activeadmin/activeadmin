Feature: Dashboard

  Background:
    Given I am logged in

  Scenario: With no configuration
    Given a configuration of:
      """
      """
    When I go to the dashboard
    Then I should see the default welcome message

  @wip
  Scenario: Displaying a dashboard page
    Given a configuration of:
      """
      ActiveAdmin.register_page "Dashboard" do
        content do
          para "Hello world from the dashboard page"
        end
      end
      """
    When I go to the dashboard
    Then I should not see the default welcome message
    And I should see "Hello world from the dashboard page"

  Scenario: Displaying a dashboard widget - Deprecated
    Given a configuration of:
      """
      ActiveAdmin::Dashboards.build do
        section 'Hello World' do
          para "Hello world from the content"
        end
      end
      """
    When I go to the dashboard
    Then I should not see the default welcome message
    And I should see a dashboard widget "Hello World"
    And I should see "Hello world from the content"

  Scenario: Displaying a dashboard widget using the ':if' option - Deprecated
    Given a configuration of:
      """
      ActiveAdmin::Dashboards.build do
        section 'Hello World', :if => proc{ current_admin_user } do
          "Hello world from the content"
        end

        section 'Hidden by If', :if => proc{ false } do
          "Hello world from the content"
        end
      end
      """
    When I go to the dashboard
    Then I should not see the default welcome message
    And I should see a dashboard widget "Hello World"
    And I should not see a dashboard widget "Hidden by If"
