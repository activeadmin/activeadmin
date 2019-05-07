Feature: Commenting

  As a user
  In order to document changes and have a discussion
  I want to store and view comments on a resource

  Background:
    Given a post with the title "Hello World" written by "Jane Doe" exists

  Scenario: View a resource with no comments
    Given a show configuration of:
      """
        ActiveAdmin.register Post
      """
    Then I should see "Comments (0)"
    And I should see "No comments yet."

  Scenario: Create a new comment
    Given a show configuration of:
      """
        ActiveAdmin.register Post
      """
    When I add a comment "Hello from Comment"
    Then I should see a flash with "Comment was successfully created"
    And I should be in the resource section for posts
    And I should see "Comments (1)"
    And I should see "Hello from Comment"
    And I should see a comment by "admin@example.com"

  Scenario: View resource with comments turned off
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        config.comments = false
      end
    """
    Then I should not see the element "div.comments.panel"

  Scenario: View a resource in a namespace that doesn't have comments
    Given a configuration of:
    """
      ActiveAdmin.application.namespace(:new_namespace).comments = false
      ActiveAdmin.register Post,      namespace: :new_namespace
      ActiveAdmin.register AdminUser, namespace: :new_namespace
    """
    And I am logged in
    When I am on the index page for posts in the new_namespace namespace
    And I follow "View"
    Then I should not see "Comments"

  Scenario: Enable comments on per-resource basis
    Given a configuration of:
    """
      ActiveAdmin.application.namespace(:new_namespace).comments = false
      ActiveAdmin.register Post,      namespace: :new_namespace do
        config.comments = true
      end
      ActiveAdmin.register AdminUser, namespace: :new_namespace
    """
    And I am logged in
    When I am on the index page for posts in the new_namespace namespace
    And I follow "View"
    Then I should see "Comments"

  Scenario: Creating a comment in one namespace does not create it in another
    Given a show configuration of:
    """
      ActiveAdmin.register Post
      ActiveAdmin.register Post,      namespace: :public
      ActiveAdmin.register AdminUser, namespace: :public
    """
    When I add a comment "Hello world in admin namespace"
    Then I should see "Hello world in admin namespace"

    When I am on the index page for posts in the public namespace
    And I follow "View"
    Then I should not see "Hello world in admin namespace"
    And I should see "Comments (0)"

    When I add a comment "Hello world in public namespace"
    Then I should see "Hello world in public namespace"
    When I am on the index page for posts in the admin namespace
    And I follow "View"
    Then I should not see "Hello world in public namespace"
    And I should see "Comments (1)"

  Scenario: Creating a comment on an aliased resource
    Given a configuration of:
    """
    ActiveAdmin.register Post, as: "Article"
    """
    And I am logged in
    When I am on the index page for articles
    And I follow "View"
    And I add a comment "Hello from Comment"
    Then I should see a flash with "Comment was successfully created"
    And I should be in the resource section for articles

  Scenario: Create an empty comment
    Given a show configuration of:
      """
        ActiveAdmin.register Post
      """
    When I add a comment ""
    Then I should see a flash with "Comment wasn't saved, text was empty."
    And I should see "Comments (0)"

  Scenario: Viewing all comments for a namespace
    Given a show configuration of:
      """
        ActiveAdmin.register Post
      """
    When I add a comment "Hello from Comment"
    And I am on the index page for comments
    Then I should see a table header with "Body"
    And I should see "Hello from Comment"

  Scenario: Commenting on a STI superclass
    Given a configuration of:
    """
      ActiveAdmin.register User
    """
    And I am logged in
    And a publisher named "Pragmatic Publishers" exists
    When I am on the index page for users
    And I follow "View"
    And I add a comment "Hello World"
    Then I should see a flash with "Comment was successfully created"
    And I should be in the resource section for users
    When I am on the index page for comments
    Then I should see the content "User"
    And I should see "Hello World"

  Scenario: Commenting on a STI subclass
    Given a configuration of:
    """
      ActiveAdmin.register Publisher
    """
    And I am logged in
    And a publisher named "Pragmatic Publishers" exists
    When I am on the index page for publishers
    And I follow "View"
    And I add a comment "Hello World"
    Then I should see a flash with "Comment was successfully created"
    And I should be in the resource section for publishers
    And I should see "Hello World"

  Scenario: Commenting on an aliased resource with an existing non-aliased config
    Given a configuration of:
    """
      ActiveAdmin.register Post
      ActiveAdmin.register Post, as: 'Foo'
    """
    And I am logged in
    When I am on the index page for foos
    And I follow "View"
    And I add a comment "Bar"
    Then I should be in the resource section for foos

  Scenario: View comments
    Given 70 comments added by admin with an email "admin@example.com"
    And a show configuration of:
      """
        ActiveAdmin.register Post
      """
    Then I should see "Comments (70)"
    And I should see "Displaying comments 1 - 25 of 70 in total"
    And I should see 25 comments
    And I should see pagination with 3 pages
    And I should see the pagination "Next" link
    When I follow "2"
    Then I should see "Displaying comments 26 - 50 of 70 in total"
    And I should see 25 comments
    And I should see the pagination "Next" link
    When I follow "Next"
    Then I should see 20 comments
    And I should see "Displaying comments 51 - 70 of 70 in total"
    And I should not see the pagination "Next" link

  Scenario: Commments through explicit helper from custom controller
    Given a post with the title "Hello World" written by "Jane Doe" exists
    And a show configuration of:
      """
        ActiveAdmin.register Post do
          controller do
            def show
              @post = Post.find(params[:id])
              show!
            end
          end

          show do |post|
            active_admin_comments
          end
        end
      """
    Then I should be able to add a comment

  @authorization
  Scenario: Not authorized to list comments
    Given 5 comments added by admin with an email "commenter@example.com"
    And 3 comments added by admin with an email "admin@example.com"
    And a show configuration of:
      """
        class NoCommentListForASpecificUser < ActiveAdmin::AuthorizationAdapter
          def authorized?(action, subject = nil)
            if action == :read && subject == ActiveAdmin::Comment
              user.email != "admin@example.com"
            else
              true
            end
          end
        end

        ActiveAdmin.application.namespace(:admin).authorization_adapter = NoCommentListForASpecificUser

        ActiveAdmin.register Post
      """
    Then I should not see "Comments"
    And I should see 0 comments
    And I should not be able to add a comment

  @authorization
  Scenario: Authorized to list and view own comments
    Given 5 comments added by admin with an email "commenter@example.com"
    And 3 comments added by admin with an email "admin@example.com"
    And a show configuration of:
      """
        class ListCommentsByCurrentUserOnly < ActiveAdmin::AuthorizationAdapter
          def scope_collection(collection, action = ActiveAdmin::Authorization::READ)
            if collection.is_a?(ActiveRecord::Relation) && collection.klass == ActiveAdmin::Comment
              collection.where(author: user)
            else
              collection
            end
          end
        end

        ActiveAdmin.application.namespace(:admin).authorization_adapter = ListCommentsByCurrentUserOnly

        ActiveAdmin.register Post
      """
    Then I should see "Comments (3)"
    And I should see 3 comments
    And I should be able to add a comment

  @authorization
  Scenario: Not authorized to create comments
    Given 5 comments added by admin with an email "commenter@example.com"
    And a show configuration of:
      """
        class NoNewComments < ActiveAdmin::AuthorizationAdapter
          def authorized?(action, subject = nil)
            if action == :create && subject == ActiveAdmin::Comment
              false
            else
              true
            end
          end
        end

        ActiveAdmin.application.namespace(:admin).authorization_adapter = NoNewComments

        ActiveAdmin.register Post
      """
    Then I should see "Comments (5)"
    And I should see 5 comments
    And I should not be able to add a comment
