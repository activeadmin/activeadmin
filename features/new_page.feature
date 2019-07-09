Feature: New Page

  Customizing the form to create new resources

  Background:
    Given a category named "Music" exists
    And a user named "John Doe" exists
    And I am logged in
    And a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title,
          :body, :position, :published_date, :starred
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
    And I should see the attribute "Category" with "Music"
    And I should see the attribute "Author" with "John Doe"

  Scenario: Generating a custom form
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title, :body, :published_date, :starred

        form do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    """
    And I follow "New Post"
    Then I should see a fieldset titled "Your Post"
    And I should see a fieldset titled "Publishing"
    When I fill in "Title" with "Hello World"
    And I fill in "Body" with "This is the body"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"

  Scenario: Generating a custom form decorated with virtual attributes
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        decorate_with PostDecorator
        permit_params :custom_category_id, :author_id, :virtual_title, :body, :published_date, :starred

        form decorate: true do |f|
          f.inputs "Your Post" do
            f.input :virtual_title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    """
    And I follow "New Post"
    Then I should see a fieldset titled "Your Post"
    And I should see a fieldset titled "Publishing"
    When I fill in "Virtual title" with "Hello World"
    And I fill in "Body" with "This is the body"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"

  @changes-filesystem
  Scenario: Generating a form from a partial
    Given "app/views/admin/posts/_form.html.erb" contains:
    """
      <% url = @post.new_record? ? admin_posts_path : admin_post_path(@post) %>
      <%= active_admin_form_for @post, url: url do |f|
            f.inputs :title, :body
            f.actions
          end %>
    """
    And a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title, :body, :published_date, :starred

        form partial: "form"
      end
    """
    When I follow "New Post"
    And I fill in "Title" with "Hello World"
    And I fill in "Body" with "This is the body"
    And I press "Create Post"
    Then I should see "Post was successfully created."
    And I should see the attribute "Title" with "Hello World"
    And I should see the attribute "Body" with "This is the body"

  Scenario: Displaying fields at runtime
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title, :body, :published_date, :starred

        form do |f|
          f.inputs "Your Post" do
            if current_admin_user && false
              f.input :title
            end

            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    """
    When I follow "New Post"
    Then I should not see "Title"
    And I should see "Body"

  Scenario: Displaying only title field defined in permit params
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.build_form_with_permitted_params_only = true
        permit_params :title
      end
    """
    When I follow "New Post"
    Then I should see "Title"
    And I should not see "Body"

  Scenario: Displaying only body field defined in permit params
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.build_form_with_permitted_params_only = true
        permit_params :body
      end
    """
    When I follow "New Post"
    Then I should not see "Title"
    And I should see "Body"

  Scenario: Displaying only title and body field defined in permit params
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        config.build_form_with_permitted_params_only = true
        permit_params [:title, :body]
      end
    """
    When I follow "New Post"
    Then I should see "Title"
    And I should see "Body"

  Scenario: Displaying only dynamic permit params
    Given 1 post with the title "Hakuna Matata" exists
    And a configuration of:
    """
      ActiveAdmin.register Post do
        config.build_form_with_permitted_params_only = true
        permit_params do
          permitted = [:title]
          permitted << :body if params[:action] == "new"
          permitted
        end
      end
    """
    When I follow "New Post"
    Then I should see "Title"
    And I should see "Body"
    When I click "Cancel"
    And I click "Edit"
    Then I should see "Title"
    And I should not see "Body"
