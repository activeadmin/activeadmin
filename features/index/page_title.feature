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

  Scenario: Set the title using a proc that uses the available resource class
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        index :title => proc{ "List of #{resource_class.model_name.plural}" }
      end
    """
    Then I should see the page title "List of posts"

  Scenario: Set the title in controller
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        controller do
          before_filter { @page_title = "List of #{resource_class.model_name.plural}" }
        end
      end
    """
    Then I should see the page title "List of posts"
