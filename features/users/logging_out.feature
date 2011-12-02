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

  Scenario: With logout_link_path set to :logout_path (the symbol)
    Given a configuration of:
      """
      ActiveAdmin.setup do |config|
        config.logout_link_path = :logout_path
      end
      """
    And I am logged in
    When I go to the dashboard
    Then I should see the default welcome message
