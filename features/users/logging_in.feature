Feature: User Logging In

  Logging in to the system as an admin user

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    And I am logged out
    And an admin user "admin@example.com" exists
    When I go to the dashboard

  Scenario: Logging in Successfully
    When I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should be on the the dashboard
    And I should see the element "a[href='/admin/logout'       ]:contains('Logout')"
    And I should see the element "a[href='/admin/admin_users/1']:contains('admin@example.com')"

  Scenario: Attempting to log in with an incorrect email address
    Given override locale "devise.failure.not_found_in_database" with "Invalid email or password."
    When I fill in "Email" with "not-an-admin@example.com"
    And I fill in "Password" with "not-my-password"
    And I press "Login"
    Then I should see "Login"
    And I should see "Invalid email or password."

  Scenario: Attempting to log in with an incorrect password
    Given override locale "devise.failure.invalid" with "Invalid email or password."
    When I fill in "Email" with "admin@example.com"
    And I fill in "Password" with "not-my-password"
    And I press "Login"
    Then I should see "Login"
    And I should see "Invalid email or password."
