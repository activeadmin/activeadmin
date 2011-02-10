Feature: User Logging In

  Logging in to the system as an admin user

  Scenario: logging in successfully
    Given I am logged out
    And an admin user "admin@example.com" exists
    And a configuration of:
    """
      ActiveAdmin.register Post
    """
    When I go to the dashboard
    And I fill in "email" with "admin@example.com"
    And I fill in "password" with "password"
    And I press "login"
    Then I should be on the the dashboard

  Scenario: Attempting to log in with an incorrent email address
    Given a configuration of:
      """
        ActiveAdmin.register Post
      """
    And I am logged out
    And an admin user "admin@example.com" exists
    When I go to the dashboard
    And I fill in "Email" with "not-an-admin@example.com"
    And I fill in "Password" with "not-my-password"
    And I press "Login"
    Then I should see "Login"
    And I should see "Invalid email or password."

  Scenario: Attempting to log in with an incorrect password
    Given a configuration of:
      """
        ActiveAdmin.register Post
      """
    And I am logged out
    And an admin user "admin@example.com" exists
    When I go to the dashboard
    And I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "not-my-password"
    And I press "Login"
    Then I should see "Login"
    And I should see "Invalid email or password."
