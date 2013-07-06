Feature: Site title

  As a developer
  In order to customize the site title
  I want to set it in the configuration

  Background:
    Given I am logged in

  Scenario: Set the site title and site title link
    Given a configuration of:
    """
      ActiveAdmin.application.site_title = "My Great Site"
      ActiveAdmin.application.site_title_link = "/admin"
    """
    When I am on the dashboard
    And I should see the site title "My Great Site"
    When I follow "My Great Site"
    Then I should see the site title "My Great Site"

  Scenario: Set the site title image
    Given a configuration of:
    """
      ActiveAdmin.application.site_title_image = "http://railscasts.com/assets/episodes/stills/284-active-admin.png?1316476106"
    """
    When I am on the dashboard
    And I should not see the site title "My Great Site"
    And I should see the site title image "http://railscasts.com/assets/episodes/stills/284-active-admin.png?1316476106"

  Scenario: Set the site title image with link
    Given a configuration of:
    """
      ActiveAdmin.application.site_title_link = "http://www.google.com"
      ActiveAdmin.application.site_title_image = "http://railscasts.com/assets/episodes/stills/284-active-admin.png?1316476106"
    """
    When I am on the dashboard
    And I should see the site title image "http://railscasts.com/assets/episodes/stills/284-active-admin.png?1316476106"
    And I should see the site title image linked to "http://www.google.com"

  Scenario: Set the site title to a proc
    Given a configuration of:
    """
      ActiveAdmin.application.site_title_image = nil # Configuration is not reset between scenarios
      ActiveAdmin.application.site_title = proc { "Hello #{controller.current_admin_user.try(:email) || 'you!'}" }
    """
    When I am on the dashboard
    And I should see the site title "Hello admin@example.com"
