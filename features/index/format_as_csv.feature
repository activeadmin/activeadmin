Feature: Format as CSV

  Background:
    Given I am logged in

  Scenario: Default
    Given a configuration of:
    """
      ActiveAdmin.register Post
    """
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    And I follow "CSV"
    And I should download a CSV file for "posts" containing:
    | Id  | Title       | Body | Published At | Starred | Created At | Updated At |
    | \d+ | Hello World |      |              |         | (.*)       | (.*)       |

  Scenario: Default with alias
    Given a configuration of:
    """
      ActiveAdmin.register Post, :as => "MyArticle"
    """
    And 1 post exists
    When I am on the index page for my_articles
    And I follow "CSV"
    And I should download a CSV file for "my-articles" containing:
    | Id  | Title       | Body | Published At | Starred | Created At | Updated At |

  Scenario: With CSV format customization
    Given a configuration of:
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
    And I should download a CSV file for "posts" containing:
    | Title        | Last update | Copyright |
    | Hello, World | (.*)        | Greg Bell |

  Scenario: With CSV format customization
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        csv :separator => ';' do
          column :title
          column :body
        end
      end
    """
    And a post with the title "Hello, World" exists
    When I am on the index page for posts
    And I follow "CSV"
    And I should download a CSV file with ";" separator for "posts" containing:
      | Title        | Body |
      | Hello, World | (.*) |

  Scenario: With CSV option customization
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        csv :options => {:force_quotes => true} do
          column :title
          column :body
        end
      end
    """
    And a post with the title "012345" exists
    When I am on the index page for posts
    And I follow "CSV"
    And I should download a CSV file with "," separator for "posts" containing:
      | Title  | Body |
      | 012345 | (.*) |
    And the CSV file should contain "012345" in quotes

  Scenario: With default CSV separator option
    Given a configuration of:
    """
      ActiveAdmin.application.csv_column_separator = ';'
      ActiveAdmin.register Post do
        csv do
          column :title
          column :body
        end
      end
    """
    And a post with the title "Hello, World" exists
    When I am on the index page for posts
    And I follow "CSV"
    And I should download a CSV file with ";" separator for "posts" containing:
      | Title | Body |
      | Hello, World | (.*) |

  Scenario: With default CSV options
    Given a configuration of:
    """
      ActiveAdmin.application.csv_options = {:force_quotes => true}
      ActiveAdmin.application.csv_column_separator = ','
      ActiveAdmin.register Post do
        csv do
          column :title
          column :body
        end
      end
    """
    And a post with the title "012345" exists
    When I am on the index page for posts
    And I follow "CSV"
    And I should download a CSV file with "," separator for "posts" containing:
      | Title  | Body |
      | 012345 | (.*) |
    And the CSV file should contain "012345" in quotes
