Feature: Index - Page Title

  Modifying the page title on the index screen

  Scenario: Set a string as the title
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        index :title => "Awesome Title"
      end
    """
    Then I should see the page title "Awesome Title"

  Scenario: Set the title using a proc
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        index :title => proc{ 'Custom title from proc' }
      end
    """
    Then I should see the page title "Custom title from proc"
