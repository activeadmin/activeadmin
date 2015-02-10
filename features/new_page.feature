Feature: New Page

  Customizing the form to create new resources

  Background:
    Given a category named "Music" exists
    Given a user named "John Doe" exists
    And I am logged in
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        if Rails::VERSION::MAJOR == 4
          permit_params :custom_category_id, :author_id, :title,
            :body, :position, :published_at, :starred
        end
      end
    """
    When I am on the index page for posts

  Scenario: Default form with no config
    Given I follow "New Post"
    When I fill in "Title" with "Hello World"
    And I fill in "Body" with "This is the body"
    And I select "Music" from "Category"
    And I select "John Doe" from "Author"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"
    #And I should see the attribute "Category" with "Music"
    And I should see the attribute "Author" with "John Doe"

  Scenario: Generating a custom form
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title, :body, :published_at, :starred if Rails::VERSION::MAJOR == 4

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
    Given I follow "New Post"
    Then I should see a fieldset titled "Your Post"
    And I should see a fieldset titled "Publishing"
    When I fill in "Title" with "Hello World"
    And I fill in "Body" with "This is the body"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"

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
        permit_params :custom_category_id, :author_id, :title, :body, :published_at, :starred if Rails::VERSION::MAJOR == 4

        form :partial => "form"
      end
    """
    Given I follow "New Post"
    When I fill in "Title" with "Hello World"
    And I fill in "Body" with "This is the body"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"

  Scenario: Displaying fields at runtime
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title, :body, :published_at, :starred if Rails::VERSION::MAJOR == 4

        form do |f|
          f.inputs "Your Post" do
            if current_admin_user && false
              f.input :title
            end

            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_at
          end
          f.actions
        end
      end
    """
    Given I follow "New Post"
    Then I should not see "Title"
    And I should see "Body"
