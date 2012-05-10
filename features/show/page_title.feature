Feature: Show - Page Title

  Modifying the page title on the show screen

  Background:
    Given a post with the title "Hello World" written by "Jane Doe" exists

  Scenario: Set a method to be called on the resource as the title
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        show :title => :title
      end
    """
    Then I should see the page title "Hello World"

  Scenario: Set a string as the title
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        show :title => "Title From String"
      end
    """
    Then I should see the page title "Title From String"

  Scenario: Set a proc as the title
    Given a show configuration of:
    """
      ActiveAdmin.register Post do
        show :title => proc{|post| "Title: " + post.title }
      end
    """
    Then I should see the page title "Title: Hello World"

  Scenario: Default title
    Given a show configuration of:
    """
      ActiveAdmin.register Post
    """
    Then I should see the page title "Hello World"

  Scenario: Default title with no display name method candidate
    Given a show configuration of:
    """
      ActiveAdmin.register Tag
    """
    Then I should see the page title "Tag #"
