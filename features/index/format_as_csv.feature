Feature: Format as CSV

  Scenario: Default with no index customization
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    And I follow "CSV"
    Then I should see the CSV:
	 | Id | Title       | Body | Published At | Created At | Updated At |
	 | 1  | Hello World |      |              | (.*)       | (.*)       |

  Scenario: With index customization

  Scenario: With CSV format customization

