Feature: Breadcrumb

  Background:
    Given I am logged in

  Scenario: Default breadcrumb links
    Given a configuration of:
    """
      ActiveAdmin.register Post do
      end
    """
    When I am on the new post page
    Then I should see a link to "Post" in the breadcrumb
    
  Scenario: Rewritten breadcrumb links
    Given a configuration of:
    """
      ActiveAdmin.register Post do
        breadcrumb do
          [
            link_to('test', '/admin/test/url')
          ]
        end
      end
    """
    When I am on the new post page
    Then I should see a link to "test" in the breadcrumb