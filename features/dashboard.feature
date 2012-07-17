Feature: Dashboard

  @dashboard
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

  @dashboard
  Scenario: DEPRECATED - With default configuration
    Given a configuration of:
      """
        ActiveAdmin::Dashboards.build do
        end
      """
    Given I am logged in
    When I go to the dashboard
    Then I should see the Active Admin layout
    And I should see the default welcome message

  @dashboard
  Scenario: DEPRECATED - Displaying a dashboard widget
    Given a configuration of:
      """
      ActiveAdmin::Dashboards.build do
        section 'Hello World' do
          para "Hello world from the content"
        end
      end
      """
    Given I am logged in
    When I go to the dashboard
    Then I should see the Active Admin layout
    And I should not see the default welcome message
    And I should see a dashboard widget "Hello World"
    And I should see "Hello world from the content"

  @dashboard
  Scenario: DEPRECATED - Displaying a dashboard widget using the ':if' option
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
    Given I am logged in
    When I go to the dashboard
    Then I should see the Active Admin layout
    And I should not see the default welcome message
    And I should see a dashboard widget "Hello World"
    And I should not see a dashboard widget "Hidden by If"
