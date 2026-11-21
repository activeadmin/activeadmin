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
end
