Feature: Menu

  Background:
    Given I am logged in

  Scenario: Hide the menu item
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        menu false
      end
    """
    When I am on the dashboard
    Then I should not see a menu item for "Posts"

  Scenario: Set the menu item label
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        menu :label => "Articles"
      end
    """
    When I am on the dashboard
    Then I should see a menu item for "Articles"
    And I should not see a menu item for "Posts"

  Scenario: Set the site title and site title link
    Given a configuration of:
    """
      ActiveAdmin.application.site_title = "My Great Site"
      ActiveAdmin.application.site_title_link = "http://www.google.com/"
    """
    When I am on the dashboard
    And I should see the site title "My Great Site"
    When I follow "My Great Site"
    Then I should see "Ruby on Rails: Welcome aboard"
    # Why won't it take me to the Googles??? It takes me to / instead. Oh well

  Scenario: Set the site title image
	Given a configuration of:
	"""
	  ActiveAdmin.application.site_title = "My Great Site"
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