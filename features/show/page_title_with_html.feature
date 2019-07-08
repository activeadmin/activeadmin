Feature: Show - Page Title with HTML

  Page Title is escaped

  Scenario: Set an HTML string as the title
    Given a post with the title "<a href='https://somewhere-nasty.com/'>John Doe</a>" written by "Jane Doe" exists
    And a show configuration of:
    """
      ActiveAdmin.register Post
    """
    Then I should see the page title "<a href='https://somewhere-nasty.com/'>John Doe</a>"
