Feature: Development Reloading

  In order to quickly develop applications
  As a developer
  I want the application to reload itself in development

  @requires-reloading
  Scenario: Reloading an updated model that a resource points to
    Given "app/admin/posts.rb" contains:
    """
      ActiveAdmin.register Post
    """
    And I am logged in with capybara
    And I create a new post with the title ""
    Then I should see a successful create flash
    Given I add "validates_presence_of :title" to the "post" model
    And I create a new post with the title ""
    Then I should not see a successful create flash
    And I should see a validation error "can't be blank"


  # TODO: Create a scenario that reloads one of the active admin
  # configuration files.
  #
  # @requires-reloading
  # Scenario: Reloading an updated model that a resource points to
  #   Given "app/admin/posts.rb" contains:
  #   """
  #     ActiveAdmin.register Post
  #     ActiveAdmin.register User
  #   """
  #   And I am logged in
  #   Then I should see a menu item for "Posts"

  #   Given "app/admin/posts.rb" contains:
  #   """
  #     ActiveAdmin.register Post, :as => "Blog"
  #     ActiveAdmin.register User
  #   """
  #   When I follow "Users"
  #   Then show me the page
  #   Then I should see a menu item for "Blogs"
  #   Then I should not see a menu item for "Posts"
