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

  context "when saving nested posts" do
    around do |example|
      validation = proc { errors.add(:first_name, :blank) if first_name.blank? }
      User.validate(&validation)
      example.run
    ensure
      User.skip_callback(:validate, :before, validation)
    end

    before do
      register_resources do
        ActiveAdmin.register User do
          permit_params :first_name, :last_name, posts_attributes: [:id, :title, :body, :_destroy]

          form do |f|
            f.inputs do
              f.input :first_name
              f.input :last_name
              f.has_many :posts, allow_destroy: true do |ff|
                ff.input :title
                ff.input :body
              end
            end
            f.actions
          end
        end
      end
    end

    it "saves distinct new children after removing a field group and deletes an existing child" do
      visit edit_admin_user_path(author)
      click_link "Add New Post", exact: true

      expect(page).to have_css(".has-many-container fieldset", count: 2)
      within(all(".has-many-container fieldset")[1]) { fill_in "Title", with: "Discard this post" }

      click_link "Add New Post", exact: true

      expect(page).to have_css(".has-many-container fieldset", count: 3)
      within(all(".has-many-container fieldset")[2]) do
        fill_in "Title", with: "First saved post"
        fill_in "Body", with: "First body"
      end
      within(all(".has-many-container fieldset")[1]) { click_link "Remove", exact: true }

      expect(page).to have_css(".has-many-container fieldset", count: 2)
      click_link "Add New Post", exact: true

      expect(page).to have_css(".has-many-container fieldset", count: 3)
      within(all(".has-many-container fieldset")[2]) do
        fill_in "Title", with: "Second saved post"
        fill_in "Body", with: "Second body"
      end

      title_fields = all(".has-many-container input[name$='[title]']")
      expect(title_fields.map { |field| field[:id] }.uniq.size).to eq(3)
      expect(title_fields.map { |field| field[:name] }.uniq.size).to eq(3)
      within(first(".has-many-container fieldset")) { check "Delete" }
      click_button "Update User"

      expect(page).to have_text("User was successfully updated.")
      expect(Post.exists?(post.id)).to be(false)
      expect(author.posts.order(:id).pluck(:title, :body)).to eq [
        ["First saved post", "First body"],
        ["Second saved post", "Second body"]
      ]
    end

    it "retains nested values after a validation error and saves them after correction" do
      visit edit_admin_user_path(author)
      fill_in "First name", with: ""
      within(first(".has-many-container fieldset")) { fill_in "Title", with: "Edited existing post" }
      click_link "Add New Post", exact: true

      expect(page).to have_css(".has-many-container fieldset", count: 2)
      within(all(".has-many-container fieldset")[1]) do
        fill_in "Title", with: "New child post"
        fill_in "Body", with: "Retained child body"
      end
      click_button "Update User"

      expect(page).to have_css(".inline-errors", text: "can't be blank")
      expect(page).to have_field("First name", with: "")
      expect(page).to have_css(".has-many-container fieldset", count: 2)
      within(first(".has-many-container fieldset")) { expect(page).to have_field("Title", with: "Edited existing post") }
      within(all(".has-many-container fieldset")[1]) do
        expect(page).to have_field("Title", with: "New child post")
        expect(page).to have_field("Body", with: "Retained child body")
      end
      expect(author.reload.first_name).to eq("John")
      expect(post.reload.title).to eq("Hello World")
      expect(author.posts.count).to eq(1)

      fill_in "First name", with: "Jane"
      click_button "Update User"

      expect(page).to have_text("User was successfully updated.")
      expect(author.reload.first_name).to eq("Jane")
      expect(post.reload.title).to eq("Edited existing post")
      expect(author.posts.order(:id).pluck(:title)).to eq(["Edited existing post", "New child post"])
      expect(author.posts.find_by!(title: "New child post").body).to eq("Retained child body")
    end
  end
end
