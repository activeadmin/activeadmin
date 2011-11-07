Feature: Registering Pages

  Registering pages within Active Admin

  Background:
    Given I am logged in

  Scenario: Registering a page
    Given a configuration of:
    """ 
    ActiveAdmin.page "Status" do
      content do
        h1 "Current Status"
      end
    end
    """
    When I go to the dashboard
    Then I should see "Status"
    When I follow "Status"
    Then I should see "Current Status"

