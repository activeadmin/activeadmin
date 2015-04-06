Feature: Show - Columns

  Columns in show page

  Background:
    Given a post with the title "Hello World" written by "Jane Doe" exists

  Scenario:
    Given a show configuration of:
    """
      ActiveAdmin.register Post do

        show do
          columns do
          end
        end

      end
    """
    Then I should see a columns container
    And I should see 0 column

  Scenario:
    Given a show configuration of:
    """
      ActiveAdmin.register Post do

        show do
          columns do
            column do
            end
            column do
            end
          end
        end

      end
    """
    Then I should see a columns container
    And I should see 2 columns
