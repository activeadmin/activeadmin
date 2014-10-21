Feature: Development Reloading

  In order to quickly develop applications
  As a developer
  I want the application to reload itself in development

  @requires-reloading
  Scenario: Registering a resource that was not previously registered
    When I am logged in with capybara
    Then I should not see a menu item for "Posts"

    When "app/admin/posts.rb" contains:
    """
      ActiveAdmin.register Post do
        if Rails::VERSION::MAJOR == 4
          permit_params :custom_category_id, :author_id, :title,
            :body, :position, :published_at, :starred
        end
      end
    """
    When I am logged in with capybara
    Then I should see a menu item for "Posts"

    When I create a new post with the title "A"
    Then I should see a successful create flash

    When I add "validates_presence_of :title" to the "post" model
    And I create a new post with the title ""
    Then I should not see a successful create flash
    And I should see a validation error "can't be blank"
