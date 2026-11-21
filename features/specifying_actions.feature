Feature: Specifying Actions

  Specifying which actions to allow on my resource

  Scenario: Only creating the index action
    Given a configuration of:
      """
        ActiveAdmin.register Post do
          actions :index
          index do
            column do |post|
              link_to "View", "/admin/posts/1"
            end
          end
        end
      """
    And I am logged in
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    Then an "ActionController::RoutingError" exception should be raised when I follow "View"

  Scenario: Specify a custom member action with multiple http methods
    Given a configuration of:
      """
        ActiveAdmin.register Post do
          action_item(:get_check, only: :show) do
            link_to('Get Check', check_admin_post_path)
          end

          action_item(:post_check, only: :show) do
            link_to('Post Check', check_admin_post_path, method: :post)
          end

          member_action :check, method: [:get, :post] do
             redirect_to admin_post_path(resource), notice: "Checked via #{request.method}"
          end
        end
      """
    And I am logged in
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    And I follow "View"
    And I follow "Get Check"
    Then I should see "Checked via GET"
    When I follow "Post Check"
    Then I should see "Checked via POST"
