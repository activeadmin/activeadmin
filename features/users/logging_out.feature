Feature: User Logging out

  Logging out of the system as an admin user

  Scenario: Logging out successfully
    Given a configuration of:
    """
      ActiveAdmin.setup do |config|
        config.logout_link_method = :get
      end
    """
    And I am logged in
    When I go to the dashboard
    Then I should see the element "a[data-method='get']:contains('Sign out')"
    And I follow "Sign out"
    And I should see "Sign In"

  Scenario: Logging out sucessfully with delete method
    Given a configuration of:
    """
      ActiveAdmin.setup do |config|
        config.logout_link_method = :delete
      end
    """
    And I am logged in
    When I am on the dashboard
    Then I should see the element "a[data-method='delete']:contains('Sign out')"
    And I follow "Sign out"
    And I should see "Sign In"
