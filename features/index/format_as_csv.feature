Feature: Format as CSV

  Scenario: Default with no index customization
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    And I follow "CSV"
    Then I should see the CSV:
    | Id  | Title       | Body | Published At | Created At | Updated At | 
    | \d+ | Hello World |      |              | (.*)       | (.*)       | 

  Scenario: With CSV format customization
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        csv do
          column :title
          column("Last update") { |post| post.updated_at }
          column("Copyright")   { "Greg Bell" }
        end
      end
    """
    And a post with the title "Hello, World" exists
    When I am on the index page for posts
    And I follow "CSV"
    Then I should see the CSV:
    | Title        | Last update | Copyright |
    | Hello, World | (.*)        | Greg Bell |

