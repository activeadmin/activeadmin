Feature: Meta Tag

  Add custom meta tags to head of pages.

  Scenario: Logged out views include custom meta tags
    Given a configuration of:
    """
      ActiveAdmin.application.meta_tags_for_logged_out_pages = { robots: 'noindex' }
    """
    And I am logged out
    When I am on the login page
    Then the site should contain a meta tag with name "robots" and content "noindex"

  Scenario: Logged in views include custom meta tags
    Given a configuration of:
    """
      ActiveAdmin.register Post
      ActiveAdmin.application.meta_tags = { author: 'My Company' }
    """
    And I am logged in
    When I am on the dashboard
    Then the site should contain a meta tag with name "author" and content "My Company"
