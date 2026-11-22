# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index as table", type: :request do
  def register_post_index(&block)
    register_resources { ActiveAdmin.register(Post, &block) }
  end

  def posts_table
    table_rows(response_html, "table#index_table_posts")
  end

  def create_post(title: "Hello World", body: "From the body")
    Post.create!(title: title, body: body)
  end

  describe "default table" do
    let!(:post_record) { create_post }

    it "renders a table with sortable id and title columns" do
      register_post_index

      get admin_posts_path

      expect(response_html).to have_table("index_table_posts")
      expect(response_html).to have_table_header("Id", sortable: true)
      expect(response_html).to have_table_header("Title", sortable: true)
    end

    it "shows each record with formatted dates and View, Edit and Delete links" do
      register_post_index

      get admin_posts_path

      row = posts_table[1]
      expect(row).to include("Hello World")
      expect(row[posts_table[0].index("Created At")]).to match(/\A\w+ \d{1,2}, \d{4} \d{2}:\d{2}\z/)
      actions = response_html.find(".data-table-resource-actions")
      expect(response_html).to have_member_link("View", href: admin_post_path(post_record))
      expect(response_html).to have_member_link("Edit", href: edit_admin_post_path(post_record))
      expect(actions).to have_css("a[href='#{admin_post_path(post_record)}'][data-method=delete]", exact_text: "Delete")
    end

    it "links the id column to the edit page when there's no show action" do
      register_post_index { actions :index, :edit, :update }

      get admin_posts_path

      expect(response_html).to have_text("Hello World")
      expect(response_html).to have_css(".data-table td a[href='#{edit_admin_post_path(post_record)}']", exact_text: post_record.id.to_s)
      expect(response_html).to have_member_link("Edit")
    end
  end

  it "links a registered association to its record" do
    category = Category.create!(name: "Non-Fiction")
    Post.create!(title: "Hello World", category: category)
    register_resources do
      ActiveAdmin.register Category
      ActiveAdmin.register Post
    end

    get admin_posts_path

    expect(response_html.find(".data-table")).to have_link("Non-Fiction", href: admin_category_path(category), exact: true)
  end

  it "makes counter-cache-like columns sortable" do
    User.create!(first_name: "Jane", last_name: "Doe", username: "jane_doe")
    register_resources { ActiveAdmin.register(User) }

    get admin_users_path

    expect(response_html).to have_table_header("Sign In Count", sortable: true)
  end

  describe "custom columns" do
    before { create_post }

    it "uses attribute names" do
      register_post_index do
        index do
          column :title
          column :body
        end
      end

      get admin_posts_path

      expect(response_html).to have_table_header("Title", sortable: true)
      expect(response_html).to have_table_header("Body", sortable: true)
      expect(response_html).to have_text("Hello World")
      expect(response_html).to have_text("From the body")
    end

    it "uses blocks with custom titles" do
      register_post_index do
        index do
          column("My Title") { |post| post.title }
          column("My Body") { |post| post.body }
        end
      end

      get admin_posts_path

      expect(response_html).to have_table_header("My Title")
      expect(response_html).to have_table_header("My Body")
      expect(response_html).to have_text("Hello World")
      expect(response_html).to have_text("From the body")
    end

    it "shows or hides columns based on the current user" do
      # Request specs run without a current user; this one needs one.
      set_application_setting(:current_user_method, :current_admin_user)
      login_as_admin
      register_post_index do
        index do
          column :title if current_active_admin_user
          column :body if current_active_admin_user.nil?
        end
      end

      get admin_posts_path

      expect(response_html).to have_table_header("Title", sortable: true)
      expect(response_html).to have_no_css("th", exact_text: "Body")
      expect(response_html).to have_text("Hello World")
      expect(response_html).to have_no_text("From the body")
    end
  end

  describe "actions column" do
    before { create_post }

    it "shows only links for the resource's actions" do
      register_post_index { actions :index, :show, :edit, :update }

      get admin_posts_path

      expect(response_html).to have_member_link("View")
      expect(response_html).to have_member_link("Edit")
      expect(response_html).to have_no_css(".data-table-resource-actions > a", exact_text: "Delete")
    end

    it "accepts a custom class and title" do
      register_post_index do
        index do
          column :category
          actions class: "custom-column-class", name: "That text"
        end
      end

      get admin_posts_path

      expect(response_html).to have_css("th.custom-column-class", exact_text: "That text")
    end

    it "adds custom items after the default links" do
      register_post_index do
        actions :index, :show, :edit, :update

        index do
          column :category
          actions { |post| item "Custom Action", edit_admin_post_path(post) }
        end
      end

      get admin_posts_path

      expect(response_html).to have_member_link("View")
      expect(response_html).to have_member_link("Edit")
      expect(response_html).to have_no_css(".data-table-resource-actions > a", exact_text: "Delete")
      expect(response_html).to have_member_link("Custom Action")
    end

    it "shows only custom items with defaults: false" do
      register_post_index do
        actions :index, :show, :edit, :update

        index do
          column :category
          actions(defaults: false) { |post| item "Custom Action", edit_admin_post_path(post) }
        end
      end

      get admin_posts_path

      expect(response_html).to have_member_link("Custom Action")
      expect(response_html).to have_no_css(".data-table-resource-actions > a", exact_text: "View")
      expect(response_html).to have_no_css(".data-table-resource-actions > a", exact_text: "Edit")
      expect(response_html).to have_no_css(".data-table-resource-actions > a", exact_text: "Delete")
    end

    it "shows no links when the resource only has an index" do
      register_post_index { actions :index }

      get admin_posts_path

      expect(response_html).to have_text("Hello World")
      expect(response_html).to have_no_css(".data-table-resource-actions > a")
    end
  end

  describe "sortable columns" do
    before { create_post }

    it "doesn't make association columns sortable" do
      register_post_index { index { column :category } }

      get admin_posts_path

      expect(response_html).to have_table_header("Category")
      expect(response_html).to have_no_css("th[data-sortable]", exact_text: "Category")
    end

    it "makes block columns sortable by default, except associations" do
      register_post_index do
        index do
          column(:author_id) {}
          column("published_date") {}
          column(:category) {}
        end
      end

      get admin_posts_path

      expect(response_html).to have_table_header("Author", sortable: true)
      expect(response_html).to have_table_header("published_date", sortable: true)
      expect(response_html).to have_table_header("Category")
      expect(response_html).to have_no_css("th[data-sortable]", exact_text: "Category")
    end

    it "doesn't make block columns sortable with sortable: false" do
      register_post_index do
        index do
          column(:author_id, sortable: false) {}
          column("published_date", sortable: false) {}
        end
      end

      get admin_posts_path

      expect(response_html).to have_table_header("Author")
      expect(response_html).to have_no_css("th[data-sortable]", exact_text: "Author")
      expect(response_html).to have_table_header("published_date")
      expect(response_html).to have_no_css("th[data-sortable]", exact_text: "published_date")
    end
  end

  describe "sorting" do
    def follow_header_link(text)
      get response_html.find("th[data-sortable] a", exact_text: text)[:href]
    end

    it "sorts by id descending by default and ascending from the header link" do
      hello_post = create_post
      bye_post = create_post(title: "Bye bye world", body: "Move your...")
      register_post_index

      get admin_posts_path

      header = ["[ ]", "Id", "Title", "Body", "Published Date", "Author", "Position", "Category", "Starred", "Foo", "Created At", "Updated At", ""]
      hello = ["[ ]", hello_post.id.to_s, "Hello World", "From the body", "", "", "", "", "Unknown", "", /./, /./, "View Edit Delete"]
      bye = ["[ ]", bye_post.id.to_s, "Bye bye world", "Move your...", "", "", "", "", "Unknown", "", /./, /./, "View Edit Delete"]

      expect(posts_table).to match([header, bye, hello])

      follow_header_link("Id")

      expect(posts_table).to match([header, hello, bye])
    end

    it "sorts by a virtual column" do
      hello_post = create_post
      bye_post = create_post(title: "Bye bye world")
      register_post_index do
        controller do
          def scoped_collection
            Post.select("id, title, length(title) as title_length")
          end
        end

        index do
          column :id
          column :title
          column("Title Length", sortable: :title_length) { |post| post.title_length }
        end
      end

      get admin_posts_path
      follow_header_link("Title Length")

      expect(posts_table).to eq [
        ["Id", "Title", "Title Length"],
        [bye_post.id.to_s, "Bye bye world", "13"],
        [hello_post.id.to_s, "Hello World", "11"]
      ]

      follow_header_link("Title Length")

      expect(posts_table).to eq [
        ["Id", "Title", "Title Length"],
        [hello_post.id.to_s, "Hello World", "11"],
        [bye_post.id.to_s, "Bye bye world", "13"]
      ]
    end
  end
end
