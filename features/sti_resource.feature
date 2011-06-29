Feature: STI Resource

  Ensure that standard CRUD works with STI models

  Background:
    Given I am logged in
    And a configuration of:
    """
      ActiveAdmin.register Publisher
      ActiveAdmin.register User
    """

  Scenario: Create, update and delete a child STI resource
    Given I am on the index page for publishers
    When I follow "New Publisher"
    And I fill in "First name" with "Terry"
    And I fill in "Last name" with "Fox"
    And I fill in "Username" with "terry_fox"
    And I press "Create Publisher"
    Then I should see "Publisher was successfully created"
    And I should see "Terry"

    When I follow "Edit Publisher"
    And I fill in "First name" with "Joe"
    And I press "Update Publisher"
    Then I should see "Publisher was successfully updated"
    And I should see "Joe"

    When I follow "Delete Publisher"
    Then I should see "Publisher was successfully destroyed"

  Scenario: Create, update and delete a parent STI resource
    Given I am on the index page for users
    When I follow "New User"
    And I fill in "First name" with "Terry"
    And I fill in "Last name" with "Fox"
    And I fill in "Username" with "terry_fox"
    And I press "Create User"
    Then I should see "User was successfully created"
    And I should see "Terry"

    When I follow "Edit User"
    And I fill in "First name" with "Joe"
    And I press "Update User"
    Then I should see "User was successfully updated"
    And I should see "Joe"

    When I follow "Delete User"
    Then I should see "User was successfully destroyed"

  Scenario: Update and delete a child STI when the parent is registered
    Given a publisher named "Terry Fox" exists
    And I am on the index page for users
    When I follow "Edit"
    And I fill in "First name" with "Joe"
    And I press "Update Publisher"
    Then I should see "Publisher was successfully updated"
    And I should see "Joe"

    When I follow "Delete User"
    Then I should see "Publisher was successfully destroyed"
