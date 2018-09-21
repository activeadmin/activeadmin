Feature: Filter Attributes

  Filtering sensitive attributes

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register User
    """
    Given I am logged in
    And a user named "John Doe" exists
    And I am on the index page for users

  Scenario: Default index page
    Then I should not see "Encrypted"
    But I should see "Age"

  Scenario: Default new form
    Given I follow "New User"
    Then I should not see "Encrypted"
    But I should see "Age"

  Scenario: Default edit form
    Given I follow "Edit"
    Then I should not see "Encrypted"
    But I should see "Age"

  Scenario: Default show page
    Given I follow "View"
    Then I should not see "Encrypted"
    But I should see "Age"

  Scenario: Default CSV export
    Given I follow "CSV"
    Then I should not see "Encrypted"
    But I should see "Age"

  # TODO: JSON
  # Scenario: Default JSON
  #   Given I follow "JSON"
  #   Then I should not see "encrypted"
  #   But I should see "age"

  Scenario: Default XML
    Given I follow "XML"
    Then I should not see "encrypted"
