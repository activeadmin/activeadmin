Feature: Robots Meta Tag for Logged Out Pages

  Prevent Devise pages from showing up in search engine results.

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register Post
      ActiveAdmin.application.robots_meta_tag_for_logged_out_pages = "noindex, nofollow"
    """

  Scenario: Logged out views show Favicon
    Given I am logged out
    When I am on the login page
    Then the site should contain a meta tag with name "robots" and content "noindex, nofollow"