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

  Scenario: Specify a custom collection action with template
    Given a configuration of:
      """
        ActiveAdmin.register Post do
          action_item(:import, only: :index) do
            link_to('Import Posts', import_admin_posts_path)
          end

          collection_action :import
        end
      """
    Given "app/views/admin/posts/import.html.arb" contains:
      """
        para "We are currently working on this feature..."
      """
    And I am logged in
    When I am on the index page for posts
    And I follow "Import"
    Then I should see "We are currently working on this feature"

  Scenario: Specify a custom member action with template
    Given a configuration of:
      """
        ActiveAdmin.register Post do
          action_item(:review, only: :show) do
            link_to('Review', review_admin_post_path)
          end

          member_action :review do
            @post = Post.find(params[:id])
          end
        end
      """
    Given "app/views/admin/posts/review.html.erb" contains:
      """
        <h1>Review: <%= @post.title %></h1>
      """
    And I am logged in
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    And I follow "View"
    And I follow "Review"
    Then I should see "Review: Hello World"
    And I should see the page title "Review"
    And I should see the Active Admin layout

  Scenario: Specify a custom member action with template using arb
    Given a configuration of:
      """
        ActiveAdmin.register Post do
          action_item(:review, only: :show) do
            link_to('Review', review_admin_post_path)
          end

          member_action :review do
            @post = Post.find(params[:id])
          end
        end
      """
    Given "app/views/admin/posts/review.html.arb" contains:
      """
        h1 "Review: #{post.title}"
      """
    And I am logged in
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    And I follow "View"
    And I follow "Review"
    Then I should see "Review: Hello World"
    And I should see the page title "Review"
    And I should see the Active Admin layout

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