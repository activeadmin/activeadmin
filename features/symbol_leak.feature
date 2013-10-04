Feature: User input shouldn't be symbolized

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    Given I am logged in
    And 1 post exists

  Scenario: The dashboard doesn't leak
    Given I am on the dashboard with params "?really_long_malicious_key0"
    Then "really_long_malicious_key0" shouldn't be a symbol

  Scenario: The index page doesn't leak
    Given I am on the index page for posts with params "?really_long_malicious_key1"
    Then "really_long_malicious_key1" shouldn't be a symbol

  @allow-rescue
  Scenario: The filter query hash doesn't leak
    Given I am on the index page for posts with params "?q[really_long_malicious_key2]"
    Then "really_long_malicious_key2" shouldn't be a symbol

  Scenario: The show page doesn't leak
    Given I go to the first post show page with params "?really_long_malicious_key3"
    Then "really_long_malicious_key3" shouldn't be a symbol

  Scenario: The edit page doesn't leak
    Given I go to the first post edit page with params "?really_long_malicious_key4"
    Then "really_long_malicious_key4" shouldn't be a symbol

  @allow-rescue
  Scenario: Batch Actions don't leak
    Given I POST to "admin/posts/batch_action" with params "?batch_action=really_long_malicious_key5"
    Then "really_long_malicious_key5" shouldn't be a symbol
