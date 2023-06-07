Feature: User Resetting Password

  Resetting my password as an admin user

  Background:
    Given I am logged out
    And an admin user "admin@example.com" exists

  Scenario: Resetting password successfully
    When I go to the dashboard
    And I follow "Forgot your password?"
    And I fill in "Email" with "admin@example.com"
    And I press "Reset My Password"
    Then I should see "You will receive an email with instructions on how to reset your password in a few minutes."

  @mocks
  Scenario: Changing password after resetting
    When "admin@example.com" requests a password reset with token "foobarbaz"
    And I go to the admin password reset form with token "foobarbaz"
    And I fill in the password field with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Change my password"
    Then I should see "success"

  @mocks
  Scenario: Changing password after resetting with errors
    When "admin@example.com" requests a password reset with token "foobarbaz" but it expires
    And I go to the admin password reset form with token "foobarbaz"
    And I fill in the password field with "password"
    And I fill in "Password confirmation" with "wrong"
    And I press "Change my password"
    Then I should see "expired"
