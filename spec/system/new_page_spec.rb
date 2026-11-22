# frozen_string_literal: true
require "rails_helper"

RSpec.describe "New page", type: :system do
  before do
    Category.create!(name: "Music")
    User.create!(first_name: "John", last_name: "Doe", username: "john_doe")
    login_as_admin
  end

  context "with a form partial" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register Post do
          permit_params :custom_category_id, :author_id, :title, :body, :published_date, :starred

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

    it "renders the partial and creates the record" do
      visit admin_posts_path
      click_on "New Post"
      fill_in "Title", with: "Hello World"
      fill_in "Body", with: "This is the body"
      click_on "Create Post"

      expect(page).to have_text("Post was successfully created.")
      expect(page).to have_attributes_table_text("Title", "Hello World")
      expect(page).to have_attributes_table_text("Body", "This is the body")
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
    click_link "New Post", exact: true
    fill_in "Title", with: "Hello World"
    fill_in "Body", with: "This is the body"
    select "Music", from: "Category"
    select "John Doe", from: "Author"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_attributes_table_text("Title", "Hello World")
    expect(page).to have_attributes_table_text("Body", "This is the body")
    expect(page).to have_attributes_table_text("Category", "Music")
    expect(page).to have_attributes_table_text("Author", "John Doe")
  end

  it "submits a custom form" do
    register_resources do
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title, :body, :published_date, :starred

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
    click_link "New Post", exact: true

    expect(page).to have_css("fieldset legend", exact_text: "Your Post")
    expect(page).to have_css("fieldset legend", exact_text: "Publishing")

    fill_in "Title", with: "Hello World"
    fill_in "Body", with: "This is the body"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_attributes_table_text("Title", "Hello World")
    expect(page).to have_attributes_table_text("Body", "This is the body")
  end

  it "calls a form helper with keyword arguments" do
    register_resources do
      ActiveAdmin.register Post do
        form do |f|
          f.inputs "Publishing" do
            f.input :published_date, input_html: { "data-time" => format_time(Time.current, format: :short) }
          end
          f.actions
        end
      end
    end

    visit admin_posts_path
    click_link "New Post", exact: true

    expect(page).to have_css("fieldset legend", exact_text: "Publishing")
  end

  it "calls a form helper without keyword arguments" do
    register_resources do
      ActiveAdmin.register Post do
        form do |f|
          f.inputs "Publishing" do
            f.input :published_date, input_html: { "data-time" => format_time(Time.current) }
          end
          f.actions
        end
      end
    end

    visit admin_posts_path
    click_link "New Post", exact: true

    expect(page).to have_css("fieldset legend", exact_text: "Publishing")
  end

  it "submits a decorated form with virtual attributes" do
    register_resources do
      ActiveAdmin.register Post do
        decorate_with PostDecorator
        permit_params :custom_category_id, :author_id, :virtual_title, :body, :published_date, :starred

        form decorate: true do |f|
          f.inputs "Your Post" do
            f.input :virtual_title
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

    expect(page).to have_css("fieldset legend", exact_text: "Your Post")
    expect(page).to have_css("fieldset legend", exact_text: "Publishing")

    fill_in "Virtual title", with: "Hello World"
    fill_in "Body", with: "This is the body"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_attributes_table_text("Title", "Hello World")
    expect(page).to have_attributes_table_text("Body", "This is the body")
  end

  it "chooses fields at runtime" do
    register_resources do
      ActiveAdmin.register Post do
        permit_params :custom_category_id, :author_id, :title, :body, :published_date, :starred

        form do |f|
          f.inputs "Your Post" do
            if current_admin_user && false
              f.input :title
            end

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

    expect(page).to have_field("Body")
    expect(page).to have_no_field("Title")
  end
end
