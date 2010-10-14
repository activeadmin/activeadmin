Feature: Logging In

  Logging in to the system as an admin user

  Scenario: Logging in successfully
    Given I am logged out
    And an admin user "admin@example.com" exists
    And a configuration of:
    """
      ActiveAdmin.register Post
    """
    When I go to the dashboard
    And I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "password"
    And I press "Sign in"
    Then I should be on the the dashboard

  Scenario: Attempting to log in with an incorrent email address
    Given I am logged out
    And an admin user "admin@example.com" exists
    And a configuration of:
      """
        ActiveAdmin.register Post
      """
    When I go to the dashboard
    And I fill in "Email" with "not-an-admin@example.com"
    And I fill in "Password" with "not-my-password"
    And I press "Sign in"
    Then I should see "Sign in"

  Scenario: Attempting to log in with an incorrect password
    Given I am logged out
    And an admin user "admin@example.com" exists
    And a configuration of:
      """
        ActiveAdmin.register Post
      """
    When I go to the dashboard
    And I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "not-my-password"
    And I press "Sign in"
    Then I should see "Sign in"
