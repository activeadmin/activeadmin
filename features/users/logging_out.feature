Feature: User Logging out

  Logging out of the system as an admin user

  Scenario: Logging out successfully
    When I am logged in
    And I go to the dashboard
    Then I should see the element "a[data-method='delete']:contains('Sign out')"
    And I follow "Sign out"
    And I should see "Sign In"
