Feature: First Boot

  As a developer
  In order to ensure I have a great first experience
  I want Active Admin to just work on install

  Scenario: Visiting /admin and logging in with no configurations
    Given a configuration of:
      """
      """
    And an admin user "admin@example.com" exists
    When I go to the dashboard
    When I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should be on the the dashboard
