Feature: Index as Blog

  Viewing resources as a blog on the index page

  Scenario: Viewing the blog with a resource
    Given a post with the title "Hello World" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index as: :blog
      end
      """
    And I am logged in
    When I am on the index page for posts
    Then I should see a blog header "Hello World"
    And I should see a link to "Hello World"

  Scenario: Viewing the blog with a resource as a simple configuration
    Given a post with the title "Hello World" and body "My great post body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index as: :blog do
          title :title
          body :body
        end
      end
      """
    Then I should see a blog header "Hello World"
    And I should see a link to "Hello World"
    And I should see "My great post body" within ".post"

  Scenario: Viewing the blog with a resource as a block configuration
    Given a post with the title "Hello World" and body "My great post body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index as: :blog do
          title do |post|
            post.title + " From Block"
          end
          body do |post|
            post.body + " From Block"
          end
        end
      end
      """
    Then I should see a blog header "Hello World From Block"
    And I should see a link to "Hello World From Block"
    And I should see "My great post body From Block" within ".post"

  Scenario: Viewing a blog with a resource as a block configuration should render Abre components
    Given a post with the title "Hello World" and body "My great post body" exists
    And an index configuration of:
      """
      ActiveAdmin.register Post do
        index as: :blog do
          title do |post|
            span(class: :title_span) { post.title + " From Block " }
          end
          body do |post|
            span(class: :body_span) { post.body + " From Block" }
          end
        end
      end
      """
      Then I should see "Hello World From Block" within "span.title_span"
      And I should see a link to "Hello World From Block"
      And I should see "My great post body From Block" within ".post span.body_span"
