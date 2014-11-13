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
    | Id  | Title       | Body | Published at | Position | Starred | Created at | Updated at |
    | \d+ | Hello World |      |              |          |         | (.*)       | (.*)       |

  Scenario: Default with alias
    Given a configuration of:
    """
      ActiveAdmin.register Post, :as => "MyArticle"
    """
    And 1 post exists
    When I am on the index page for my_articles
    And I follow "CSV"
    And I should download a CSV file for "my-articles" containing:
    | Id  | Title       | Body | Published at | Position | Starred | Created at | Updated at |

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
        csv :col_sep => ';' do
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
        csv :force_quotes => true, :byte_order_mark => "" do
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
      ActiveAdmin.application.csv_options = { :col_sep => ';' }
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
      ActiveAdmin.application.csv_options = {:col_sep => ',', :force_quotes => true}
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

    Scenario: Without CVS column names explicitely specified
    Given a configuration of:
    """
      ActiveAdmin.application.csv_options = {:col_sep => ',', :force_quotes => true}
      ActiveAdmin.register Post do
        csv :column_names => true do
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

  Scenario: Without CVS column names
    Given a configuration of:
    """
      ActiveAdmin.application.csv_options = {:col_sep => ',', :force_quotes => true}
      ActiveAdmin.register Post do
        csv :column_names => false do
          column :title
          column :body
        end
      end
    """
    And a post with the title "012345" exists
    When I am on the index page for posts
    And I follow "CSV"
    And I should download a CSV file with "," separator for "posts" containing:
      | 012345 | (.*) |

  Scenario: With encoding CSV options
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        csv :encoding => 'SJIS' do
          column :title
          column :body
        end
      end
    """
    And a post with the title "あいうえお" exists
    When I am on the index page for posts
    And I follow "CSV"
    And the encoding of the CSV file should be "SJIS"

  Scenario: With default encoding CSV options
    Given a configuration of:
    """
      ActiveAdmin.application.csv_options = { :encoding => 'SJIS' }
      ActiveAdmin.register Post do
        csv do
          column :title
          column :body
        end
      end
    """
    And a post with the title "あいうえお" exists
    When I am on the index page for posts
    And I follow "CSV"
    And the encoding of the CSV file should be "SJIS"

  Scenario: With decorator
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        decorate_with PostDecorator

        csv do
          column :id
          column :title
          column :decorator_method
        end
      end
    """
    And a post with the title "Hello World" exists
    When I am on the index page for posts
    And I follow "CSV"
    And I should download a CSV file for "posts" containing:
    | Id  | Title       | Decorator method                         |
    | \d+ | Hello World | A method only available on the decorator |
