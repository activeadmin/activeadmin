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

  Scenario: No Breadcrumbs configuration
    Given a configuration of:
    """
      ActiveAdmin.application.breadcrumb = false
      ActiveAdmin.register Post do
      end
    """
    When I am on the new post page
    Then I should see "Post"
    And I should not see the element ".breadcrumb"

  Scenario: Application config of false and a resource config of true
    Given a configuration of:
    """
      ActiveAdmin.application.breadcrumb = false
      ActiveAdmin.register Post do
        config.breadcrumb = true
      end
    """
    When I am on the new post page
    Then I should see a link to "Post" in the breadcrumb

  Scenario: Application config of false and rewritten breadcrumb links
    Given a configuration of:
    """
      ActiveAdmin.application.breadcrumb = false
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

  Scenario: Application config of true and a resource config of false
    Given a configuration of:
    """
      ActiveAdmin.application.breadcrumb = true
      ActiveAdmin.register Post do
        config.breadcrumb = false
      end
    """
    When I am on the new post page
    Then I should not see the element ".breadcrumb"
