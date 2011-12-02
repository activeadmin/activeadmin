Feature: Registering Pages

  Registering pages within Active Admin

  Background:
    Given I am logged in

  Scenario: Registering a page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      content do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see the page title "Status"
    And I should see the Active Admin layout
    And I should see the content "I love chocolate."

  Scenario: Registering an empty page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status"
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see the page title "Status"
    And I should see the Active Admin layout

  Scenario: Adding a sidebar section to a page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      sidebar :help do
        "Need help? Email us at help@example.com"
      end

      content do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see a sidebar titled "Help"


  Scenario: Adding an action item to a page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      action_item do
        link_to "Visit", "/"
      end

      content do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see an action item link to "Visit"
