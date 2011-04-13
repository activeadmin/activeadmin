Feature: User Logging out

  Logging out of the system as an admin user

  Scenario: Logging out successfully
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    And I am logged in
    When I go to the dashboard
    And I follow "Logout"
    Then I should see "Login"
