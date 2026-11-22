# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Edit page", type: :system do
  before do
    Category.create!(name: "Music")
    author = User.create!(first_name: "John", last_name: "Doe", username: "john_doe")
    Post.create!(title: "Hello World", author: author)
    Tag.create!(name: "Bugs")
    login_as_admin
  end

  context "with a form partial" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register Post do
          permit_params :category, :author, :title, :body, :published_date, :starred

          form partial: "form"
        end
      end
    end

    before do
      write_view "admin/posts/_form.html.erb", <<~ERB
        <% url = @post.new_record? ? admin_posts_path : admin_post_path(@post) %>
        <%= active_admin_form_for @post, url: url do |f|
              f.inputs :title, :body
              f.actions
            end %>
      ERB
    end

    it "renders the partial and updates the record" do
      visit admin_posts_path
      click_on "Edit"

      expect(page).to have_field("Title", with: "Hello World")
      expect(page).to have_field("Body", with: "")

      fill_in "Title", with: "Hello World from update"
      click_on "Update Post"

      expect(page).to have_text("Post was successfully updated.")
      expect(page).to have_attributes_table_text("Title", "Hello World from update")
      expect(page).to have_attributes_table_text("Author", "John Doe")
    end
  end

  it "submits the default form" do
    register_resources do
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title,
                      :body, :position, :published_date, :starred
      end
    end

    visit admin_posts_path
    click_link "Edit", exact: true

    expect(page).to have_field("Title", with: "Hello World")
    expect(page).to have_field("Body", with: "")
    expect(page).to have_field("Category", with: "")
    expect(page).to have_select("Author", selected: "John Doe")

    fill_in "Title", with: "Hello World from update"
    expect(page).to have_no_field("Create another")

    click_button "Update Post"

    expect(page).to have_text("Post was successfully updated.")
    expect(page).to have_attributes_table_text("Title", "Hello World from update")
    expect(page).to have_attributes_table_text("Author", "John Doe")
  end

  it "submits a custom form" do
    register_resources do
      ActiveAdmin.register Post do
        permit_params :category, :author, :title, :body, :published_date, :starred

        form do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    end

    visit admin_posts_path
    click_link "Edit", exact: true

    expect(page).to have_css("fieldset legend", exact_text: "Your Post")
    expect(page).to have_css("fieldset legend", exact_text: "Publishing")
    expect(page).to have_field("Title", with: "Hello World")
    expect(page).to have_field("Body", with: "")

    fill_in "Title", with: "Hello World from update"
    click_button "Update Post"

    expect(page).to have_text("Post was successfully updated.")
    expect(page).to have_attributes_table_text("Title", "Hello World from update")
    expect(page).to have_attributes_table_text("Author", "John Doe")
  end

  it "updates through a custom HTML form after visiting the new page" do
    register_resources do
      ActiveAdmin.register Post do
        permit_params :category, :author, :title, :body, :published_date, :starred

        form html: {} do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    end

    visit admin_posts_path
    click_link "New Post", exact: true
    within("nav[aria-label=breadcrumb]") { click_link "Posts", exact: true }
    click_link "Edit", exact: true

    expect(page).to have_css("fieldset legend", exact_text: "Your Post")
    expect(page).to have_css("fieldset legend", exact_text: "Publishing")
    expect(page).to have_field("Title", with: "Hello World")
    expect(page).to have_field("Body", with: "")

    fill_in "Title", with: "Hello World from update"
    click_button "Update Post"

    expect(page).to have_text("Post was successfully updated.")
    expect(page).to have_attributes_table_text("Title", "Hello World from update")
    expect(page).to have_attributes_table_text("Author", "John Doe")
  end

  it "renders a custom form for tags" do
    register_resources do
      ActiveAdmin.register Tag do
        form do |f|
          f.inputs "Details" do
            f.input :name
          end
          f.actions
        end
      end
    end

    visit admin_tags_path
    click_link "Edit", exact: true

    expect(page).to have_css("fieldset legend", exact_text: "Details")
    expect(page).to have_field("Name", with: "Bugs")
  end

  it "keeps associations unchanged after a validation failure" do
    Company.create!(name: "My company", stores: [Store.create!(name: "First store")])
    Store.create!(name: "Second store")
    visit admin_companies_path
    click_link "Edit", exact: true

    expect(page).to have_select("Stores", selected: "First store")

    fill_in "Name", with: ""
    select "Second store", from: "Stores"
    click_button "Update Company"

    expect(page).to have_text("can't be blank")

    click_link "Cancel"
    click_link "View", exact: true

    expect(page).to have_attributes_table_text("Stores", "First store")
    expect(page).not_to have_attributes_table_text("Stores", "Second store")
  end
end
