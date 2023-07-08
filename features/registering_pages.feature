Feature: Registering Pages

  Registering pages within Active Admin

  Background:
    Given I am logged in

  Scenario: Registering a page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      content do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see the page title "Status"
    And I should see the content "I love chocolate."

  Scenario: Registering a page with a complex name
    Given a configuration of:
    """
    ActiveAdmin.register_page "Chocolate I lØve You!" do
      content do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Chocolate I lØve You!"
    Then I should see the page title "Chocolate I lØve You!"
    And I should see the content "I love chocolate."

  Scenario: Registering an empty page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status"
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see the page title "Status"

  Scenario: Registering a page with a custom title as a string
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      content title: "Custom Page Title" do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see the page title "Custom Page Title"

  Scenario: Registering a page with a custom title as a proc
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      content title: proc{ "Custom Page Title from Proc" } do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see the page title "Custom Page Title from Proc"

  Scenario: Adding a sidebar section to a page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      sidebar :help do
        "Need help? Email us at help@example.com"
      end

      content do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see a sidebar titled "Help"

  Scenario: Adding an action item to a page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      action_item :visit do
        link_to "Visit", "/"
      end

      content do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    Then I should see an action item link to "Visit"

  Scenario: Adding a page action to a page with multiple http methods
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      page_action :check, method: [:get, :post] do
        redirect_to admin_status_path, notice: "Checked via #{request.method}"
      end

      action_item :post_check do
         link_to "Post Check", admin_status_check_path, method: :post
      end

      action_item :get_check do
        link_to "Get Check", admin_status_check_path
      end

      content do
        "I love chocolate."
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    And I follow "Post Check"
    Then I should see "Checked via POST"
    When I follow "Get Check"
    Then I should see "Checked via GET"

  Scenario: Adding a page action to a page
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      page_action :check do
        redirect_to admin_status_path
      end

      content do
        ("Chocolate I lØve You!" + link_to("Check", admin_status_check_path)).html_safe
      end
    end
    """
    When I go to the dashboard
    And I follow "Status"
    And I follow "Check"
    Then I should see the content "Chocolate I lØve You!"

  @changes-filesystem
  Scenario: Adding a page action to a page with erb view
    Given a configuration of:
    """
    ActiveAdmin.register_page "Status" do
      page_action :check do
      end

      content do
        ("Chocolate I lØve You!" + link_to("Check", admin_status_check_path)).html_safe
      end
    end
    """
    And "app/views/admin/status/check.html.erb" contains:
      """
        <div>Chocolate lØves You Too!</div>
      """
    When I go to the dashboard
    And I follow "Status"
    And I follow "Check"
    Then I should see the content "Chocolate lØves You Too!"

  Scenario: Registering a page with paginated index table for a collection Array
    Given a user named "John Doe" exists
    And a configuration of:
    """
    ActiveAdmin.register_page "Special users" do
      content do
        collection = Kaminari.paginate_array(User.all).page(params.fetch(:page, 1))

        table_for(collection, class: "index_table") do
          column :first_name
          column :last_name
        end

        paginated_collection(collection, entry_name: "Special users")
      end
    end
    """
    When I go to the dashboard
    And I follow "Special users"
    Then I should see the page title "Special users"
    And I should see 1 user in the table

  Scenario: Displaying parent information from a belongs_to page
    Given a configuration of:
    """
    ActiveAdmin.register Post
    ActiveAdmin.register_page "Status" do
      belongs_to :post

      content do
        "Status page for #{helpers.parent.title}"
      end
    end
    """
    And 1 post with the title "Post 1" exists
    When I go to the first post custom status page
    Then I should see the content "Status page for Post 1"
    And  I should see a link to "Post 1" in the breadcrumb

  Scenario: Rendering sortable table_for within page
    Given a configuration of:
    """
     ActiveAdmin.register Post
     ActiveAdmin.register_page "Last Posts" do
       content do
         table_for Post.last(2), sortable: true, class: "index_table" do
           column :id
           column :title
           column :author
         end
       end
    end
    """
    And a post with the title "Hello World" written by "Jane Doe" exists
    When I go to the last posts page
    Then I should see the page title "Last Posts"
    And I should see 1 post in the table
