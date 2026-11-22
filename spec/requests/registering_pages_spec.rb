# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Registering pages", type: :request do
  it "registers a page" do
    register_resources do
      ActiveAdmin.register_page "Status" do
        content do
          "I love chocolate."
        end
      end
    end

    get admin_root_path
    get response_html.find_link("Status", exact: true)[:href]

    expect(response_html).to have_page_title("Status")
    expect(response_html).to have_css("[data-test-page-content]", text: "I love chocolate.")
  end

  it "registers a page with a complex name" do
    register_resources do
      ActiveAdmin.register_page "Chocolate I lØve You!" do
        content do
          "I love chocolate."
        end
      end
    end

    get admin_root_path
    get response_html.find_link("Chocolate I lØve You!", exact: true)[:href]

    expect(response_html).to have_page_title("Chocolate I lØve You!")
    expect(response_html).to have_css("[data-test-page-content]", text: "I love chocolate.")
  end

  it "registers an empty page" do
    register_resources do
      ActiveAdmin.register_page "Status"
    end

    get admin_root_path
    get response_html.find_link("Status", exact: true)[:href]

    expect(response_html).to have_page_title("Status")
  end

  it "registers a page with a custom title as a string" do
    register_resources do
      ActiveAdmin.register_page "Status" do
        content title: "Custom Page Title" do
          "I love chocolate."
        end
      end
    end

    get admin_root_path
    get response_html.find_link("Status", exact: true)[:href]

    expect(response_html).to have_page_title("Custom Page Title")
  end

  it "registers a page with a custom title as a proc" do
    register_resources do
      ActiveAdmin.register_page "Status" do
        content title: proc { "Custom Page Title from Proc" } do
          "I love chocolate."
        end
      end
    end

    get admin_root_path
    get response_html.find_link("Status", exact: true)[:href]

    expect(response_html).to have_page_title("Custom Page Title from Proc")
  end

  it "adding a sidebar section to a page" do
    register_resources do
      ActiveAdmin.register_page "Status" do
        sidebar :help do
          "Need help? Email us at help@example.com"
        end

        content do
          "I love chocolate."
        end
      end
    end

    get admin_root_path
    get response_html.find_link("Status", exact: true)[:href]

    expect(response_html).to have_text("Need help? Email us at help@example.com")
  end

  it "adding an action item to a page" do
    register_resources do
      ActiveAdmin.register_page "Status" do
        action_item :visit do
          link_to "Visit", "/"
        end

        content do
          "I love chocolate."
        end
      end
    end

    get admin_root_path
    get response_html.find_link("Status", exact: true)[:href]

    expect(response_html).to have_css("[data-test-action-items] a", exact_text: "Visit")
  end

  it "adding a page action to a page" do
    register_resources do
      ActiveAdmin.register_page "Status" do
        page_action :check do
          redirect_to admin_status_path
        end

        content do
          ("Chocolate I lØve You!" + link_to("Check", admin_status_check_path)).html_safe
        end
      end
    end

    get admin_root_path
    get response_html.find_link("Status", exact: true)[:href]
    get response_html.find_link("Check", exact: true)[:href]
    expect(response).to redirect_to(admin_status_path)
    follow_redirect!

    expect(response_html).to have_css("[data-test-page-content]", text: "Chocolate I lØve You!")
  end

  it "registers a page with paginated index table for a collection Array" do
    User.create!(first_name: "John", last_name: "Doe", username: "johndoe")
    register_resources do
      ActiveAdmin.register_page "Special users" do
        content do
          collection = Kaminari.paginate_array(User.all).page(params.fetch(:page, 1))

          table_for(collection) do
            column :first_name
            column :last_name
          end

          paginated_collection(collection, entry_name: "Special users")
        end
      end
    end

    get admin_root_path
    get response_html.find_link("Special users", exact: true)[:href]

    expect(response_html).to have_page_title("Special users")
    expect(response_html).to have_table_rows(1)
  end

  it "shows parent information from a belongs_to page" do
    register_resources do
      ActiveAdmin.register Post
      ActiveAdmin.register_page "Status" do
        belongs_to :post

        content do
          "Status page for #{helpers.parent.title}"
        end
      end
    end
    Post.create!(title: "Post 1")
    get admin_post_status_path(Post.first)

    expect(response_html).to have_css("[data-test-page-content]", text: "Status page for Post 1")
    expect(response_html).to have_breadcrumb_link("Post 1")
  end

  it "renders sortable table_for within page" do
    register_resources do
      ActiveAdmin.register Post
      ActiveAdmin.register_page "Last Posts" do
       content do
         table_for Post.last(2), sortable: true do
           column :id
           column :title
           column :author
         end
       end
     end
    end
    author = User.find_or_create_by!(first_name: "Jane", last_name: "Doe") { |user| user.username = "janedoe" }
    Post.create!(title: "Hello World", author: author, starred: nil)
    get admin_last_posts_path

    expect(response_html).to have_page_title("Last Posts")
    expect(response_html).to have_table_rows(1)
    expect(response_html).to have_table_header("Id", sortable: true)
    expect(response_html).to have_table_header("Title", sortable: true)
    expect(response_html).to have_table_header("Author", sortable: true)
    expect(response_html.find("th", exact_text: "Id")).to have_link("Id", href: admin_last_posts_path(order: "id_desc"), exact: true)
    expect(response_html.find("th", exact_text: "Title")).to have_link("Title", href: admin_last_posts_path(order: "title_desc"), exact: true)
    expect(response_html.find("th", exact_text: "Author")).to have_link("Author", href: admin_last_posts_path(order: "author_desc"), exact: true)
  end
end
