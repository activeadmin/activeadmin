Feature: Registering Assets

  Registering CSS and JS files

  Background:
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    And I am logged in

  Scenario: Viewing default asset files
    When I am on the index page for posts
    Then I should see the css file "active_admin"
    And I should see the js file "active_admin"

  Scenario: Registering a CSS file
    Given a configuration of:
    """
      ActiveAdmin.application.register_stylesheet "some-random-css.css", media: :print
      ActiveAdmin.register Post
    """
    When I am on the index page for posts
    Then I should see the css file "some-random-css" of media "print"

  Scenario: Registering a JS file
    Given a configuration of:
    """
      ActiveAdmin.application.register_javascript "some-random-js.js"
      ActiveAdmin.register Post
    """
    When I am on the index page for posts
    Then I should see the js file "some-random-js"
