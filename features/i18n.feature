@locale_manipulation
Feature: Internationalization

  ActiveAdmin should use the translations provided by the host app.

  Scenario: Store's model name was translated to "Bookstore"
    Given I am logged in
    And a store named "Hello words" exists
    When I go to the dashboard
    Then I should see "Bookstores"

    When I follow "Bookstores"
    Then I should see the page title "Bookstores"
    And I should see "Hello words"

    When I follow "View"
    Then I should see "Hello words"
    And I should see a link to "Delete Bookstore"

    When I follow "Edit Bookstore"
    Then I should see "Edit Bookstore"

    When I press "Update Bookstore"
    Then I should see a flash with "Bookstore was successfully updated."

  Scenario: Switching language at runtime
    Given I am logged in
    When I set my locale to "fr"
    And I go to the dashboard
    Then I should see "Store"
    And I should see "Déconnexion"

    When I set my locale to "en"
    And I go to the dashboard
    Then I should see "Bookstore"
    And I should see "Sign out"

  Scenario: Overriding translations
    Given I am logged in
    And a store named "Hello words" exists
    When I go to the dashboard
    And I follow "Bookstores"
    Then I should see "Export:"
