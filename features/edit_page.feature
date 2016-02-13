Feature: Edit Page

  Customizing the form to edit resources

  Background:
    Given a category named "Music" exists
    And a user named "John Doe" exists
    And a post with the title "Hello World" written by "John Doe" exists
    And I am logged in
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        if Rails::VERSION::MAJOR >= 4
          permit_params :custom_category_id, :author_id, :title,
            :body, :position, :published_at, :starred
        end
      end
    """
    When I am on the index page for posts

  Scenario: Default form with no config
    Given I follow "Edit"
    Then the "Title" field should contain "Hello World"
    And the "Body" field should contain ""
    And the "Category" field should contain ""
    And the "Author" field should contain the option "John Doe"
    When I fill in "Title" with "Hello World from update"
    When I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"

  Scenario: Generating a custom form
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :category, :author, :title, :body, :published_at, :starred if Rails::VERSION::MAJOR >= 4

        form do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_at
          end
          f.actions
        end
      end
    """
    Given I follow "Edit"
    Then I should see a fieldset titled "Your Post"
    And I should see a fieldset titled "Publishing"
    And the "Title" field should contain "Hello World"
    And the "Body" field should contain ""
    When I fill in "Title" with "Hello World from update"
    When I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"

  Scenario: Generating a custom form with :html set, visiting the new page first (bug probing issue #109)
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :category, :author, :title, :body, :published_at, :starred if Rails::VERSION::MAJOR >= 4

        form :html => {} do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_at
          end
          f.actions
        end
      end
    """
    Given I follow "New"
    Then I follow "Posts"
    Then I follow "Edit"
    Then I should see a fieldset titled "Your Post"
    And I should see a fieldset titled "Publishing"
    And the "Title" field should contain "Hello World"
    And the "Body" field should contain ""
    When I fill in "Title" with "Hello World from update"
    When I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"

  Scenario: Generating a form from a partial
    Given "app/views/admin/posts/_form.html.erb" contains:
    """
      <% url = @post.new_record? ? admin_posts_path : admin_post_path(@post) %>
      <%= active_admin_form_for @post, :url => url do |f|
            f.inputs :title, :body
            f.actions
          end %>
    """
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :category, :author, :title, :body, :published_at, :starred if Rails::VERSION::MAJOR >= 4

        form :partial => "form"
      end
    """
    Given I follow "Edit"
    Then the "Title" field should contain "Hello World"
    And the "Body" field should contain ""
    When I fill in "Title" with "Hello World from update"
    When I press "Update Post"
    Then I should see "Post was successfully updated."
    And I should see the attribute "Title" with "Hello World from update"
    And I should see the attribute "Author" with "John Doe"
