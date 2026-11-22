# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Create another", type: :system do
  before do
    login_as_admin
  end

  it "creates another record when selected, then returns to the saved record" do
    register_resources do
      ActiveAdmin.register Post do
        config.create_another = true

        permit_params :custom_category_id, :author_id, :title,
                      :body, :position, :published_date, :starred
      end
    end

    visit admin_posts_path
    click_link "New Post", exact: true
    fill_in "Title", with: "Hello World"
    fill_in "Body", with: "This is the body"
    expect(page).to have_unchecked_field("Create another Post")
    check "Create another"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_text("New Post")
    expect(page).to have_checked_field("Create another")

    fill_in "Title", with: "Another Hello World"
    fill_in "Body", with: "This is the another body"
    uncheck "Create another"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_attributes_table_text("Title", "Another Hello World")
    expect(page).to have_attributes_table_text("Body", "This is the another body")
  end

  context "when a submitted company name is invalid" do
    around do |example|
      validation = proc { errors.add(:name, "is reserved") if name == "Reserved company" }
      Company.validate(&validation)
      example.run
    ensure
      Company.skip_callback(:validate, :before, validation)
    end

    it "retains associations and create-another state after a validation error" do
      Store.create!(name: "First store")
      second_store = Store.create!(name: "Second store")
      register_resources do
        ActiveAdmin.register Company do
          config.create_another = true
          permit_params :name, store_ids: []

          form do |f|
            f.inputs do
              f.input :name
              f.input :stores
            end
            f.actions
          end
        end
      end

      visit new_admin_company_path
      fill_in "Name", with: "Reserved company"
      select second_store.name, from: "Stores"
      check "Create another"
      click_button "Create Company"

      expect(page).to have_css(".inline-errors", text: "is reserved")
      expect(page).to have_field("Name", with: "Reserved company")
      expect(page).to have_select("Stores", selected: second_store.name)
      expect(page).to have_checked_field("Create another")
      expect(Company.count).to eq(0)

      fill_in "Name", with: "New company"
      click_button "Create Company"

      expect(page).to have_text("Company was successfully created.")
      expect(page).to have_page_title("New Company")
      expect(page).to have_checked_field("Create another")
      expect(Company.count).to eq(1)
      expect(Company.find_by!(name: "New company").store_ids).to eq([second_store.id])
    end
  end
end
