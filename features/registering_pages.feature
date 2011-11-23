Feature: Registering Pages

  Registering pages within Active Admin

  Background:
    Given I am logged in

  Scenario: Registering a page
    Given a configuration of:
    """ 
    ActiveAdmin.register_page "Status" do
      content do
        para "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see the page title "Status"
    And I should see the Active Admin layout
    And I should see the content "I love chocolate."

