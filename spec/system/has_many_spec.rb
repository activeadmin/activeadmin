# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Nested association fields", type: :system, js: true do
  let(:author) { User.create!(first_name: "John", last_name: "Doe", username: "johndoe") }
  let!(:post) { Post.create!(title: "Hello World", author: author) }

  before { login_as_admin }

  { "default" => nil, "custom" => "Hide" }.each do |label_type, remove_label|
    it "adds and removes fields with the #{label_type} remove label" do
      options = remove_label ? { remove_record: remove_label } : {}
      register_resources do
        ActiveAdmin.register User do
          form do |f|
            f.inputs do
              f.has_many :posts, options do |ff|
                ff.input :title
                ff.input :body
              end
            end
            f.actions
          end
        end
        ActiveAdmin.register Post
      end

      visit admin_user_path(author)
      click_link "Edit User", exact: true

      expect(page).to have_field("Title", with: post.title)
      expect(page).to have_link("Add New Post", exact: true)
      expect(page).to have_css(".has-many-container fieldset", count: 1)

      click_link "Add New Post", exact: true

      expect(page).to have_css(".has-many-container fieldset", count: 2)
      expect(page).to have_link(remove_label || "Remove", exact: true)

      click_link remove_label || "Remove", exact: true

      expect(page).to have_css(".has-many-container fieldset", count: 1)
      expect(page).to have_field("Title", with: post.title)
      expect(page).to have_no_link(remove_label || "Remove", exact: true)
    end
  end
end
