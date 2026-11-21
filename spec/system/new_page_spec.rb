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
      expect(page).to have_attribute_value("Title", "Hello World")
      expect(page).to have_attribute_value("Body", "This is the body")
    end
  end
end
