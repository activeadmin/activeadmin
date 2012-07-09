Feature: User Resetting Password

  Resetting my password as an admin user

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    And I am logged out
    And an admin user "admin@example.com" exists

  Scenario: Resetting password successfully
    When I go to the dashboard
    And I follow "Forgot your password?"
    When I fill in "Email" with "admin@example.com"
    And I press "Reset My Password"
    Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."

  Scenario: Changing password after resetting
    Given an admin user "admin@example.com" exists with reset password token "123reset"
    When I go to the admin password reset form with reset password token "123reset"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Change my password"
    Then I should see "success"

  Scenario: Changing password after resetting with errors
    Given an admin user "admin@example.com" exists with expired reset password token "123reset"
    When I go to the admin password reset form with reset password token "123reset"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "wrong"
    And I press "Change my password"
    Then I should see "expired"