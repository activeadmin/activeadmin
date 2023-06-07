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
    Then I should see "Bookstore Details"
    And I should see "Hello words"
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
    And I should see "Logout"

  Scenario: Overriding translations
    Given I am logged in
    And a store named "Hello words" exists
    When I go to the dashboard
    And I follow "Bookstores"
    Then I should see "Download this:"

  Scenario: Overriding resource details table title
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    And String "Post detailed information" corresponds to "resources.post.details"
    And I am logged in
    And a post exists
    When I go to the last post's show page
    Then I should see "Post detailed information"
