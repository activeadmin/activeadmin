@filters
Feature: Filters on non-ActiveRecord resources

  ActiveAdmin should let admins use the `filter` DSL on resources that
  aren't ActiveRecord-backed, without monkey-patching.

  Known limitation: the "Active Search" sidebar is coupled to Ransack,
  so for a non-Ransack `@search` it renders empty ("No filters applied")
  instead of filter chips. The filter form, "Clear Filters" link,
  pagination, and table are unaffected.

  Background:
    Given I am logged in
    And a configuration of:
    """
      ActiveAdmin.register ApiPost do
        actions :index

        filter :title_cont, as: :string, label: "Title contains"
        filter :status_eq,  as: :select, label: "Status",
               collection: %w[active inactive]

        index do
          column :id
          column :title
          column :status
        end

        controller do
          # Non-AR resources override `find_collection`; Kaminari.paginate_array
          # adapts the API response for AA's pagination UI.
          def find_collection(*)
            q = params[:q] || {}
            @search = ApiPost::Search.new(
              title_cont: q[:title_cont],
              status_eq: q[:status_eq]
            )
            page = (params[:page] || 1).to_i
            per_page = 5

            result = ApiPost.fetch(
              page: page,
              per_page: per_page,
              title_cont: @search.title_cont,
              status_eq: @search.status_eq
            )

            Kaminari.paginate_array(
              result.records,
              total_count: result.total_count,
              limit:       result.limit,
              offset:      result.offset
            ).page(page).per(per_page)
          end
        end
      end
    """

  Scenario: Server-side pagination across multiple pages
    When I am on the index page for api_posts
    Then I should see "Alpha"
    And I should see "Epsilon"
    And I should not see "Zeta"
    And I should see "Showing 1-5 of 7"
    And I should see pagination page 2 link
    And I should see the following filters:
      | Title contains | string |
      | Status         | select |

    When I follow "2"
    Then I should see "Zeta"
    And I should see "Eta"
    And I should see "Showing 6-7 of 7"
    And I should not see "Alpha"

  Scenario: Filter narrows the result set to a single page (no pagination)
    When I am on the index page for api_posts
    Then I should see pagination page 2 link

    When I select "inactive" from "Status"
    And I press "Filter"
    Then I should see "Beta"
    And I should see "Epsilon"
    And I should not see "Alpha"
    And I should not see "Gamma"
    And I should see "Showing all 2"
    And I should not see pagination

  Scenario: Filter narrows the result set to a single record
    When I am on the index page for api_posts
    And I fill in "Title contains" with "Bet"
    And I press "Filter"
    Then I should see "Beta"
    And I should not see "Alpha"
    And I should not see "Epsilon"
    And I should see "Showing 1 of 1"
    And I should not see pagination
