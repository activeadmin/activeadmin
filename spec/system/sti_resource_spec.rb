# frozen_string_literal: true
require "rails_helper"

RSpec.describe "STI resources", type: :system, js: true do
  before do
    login_as_admin
    register_resources do
      ActiveAdmin.register Publisher do
        permit_params :first_name, :last_name, :username, :age, :reason_of_sign_in
      end
      ActiveAdmin.register User do
        permit_params :first_name, :last_name, :username, :age, :reason_of_sign_in
      end
    end
  end

  it "creates, updates and deletes a child STI resource" do
    visit admin_publishers_path
    click_link "New Publisher", exact: true
    fill_in "First name", with: "Terry"
    fill_in "Last name", with: "Fox"
    fill_in "Username", with: "terry_fox"
    click_button "Create Publisher"

    expect(page).to have_text("Publisher was successfully created")
    expect(page).to have_text("Terry")
    publisher = User.find_by!(username: "terry_fox")
    expect(publisher).to have_attributes(type: "Publisher", first_name: "Terry", last_name: "Fox")

    click_link "Edit Publisher", exact: true
    fill_in "First name", with: "Joe"
    click_button "Update Publisher"

    expect(page).to have_text("Publisher was successfully updated")
    expect(page).to have_text("Joe")
    expect(publisher.reload).to have_attributes(type: "Publisher", first_name: "Joe")

    accept_confirm { click_link "Delete Publisher", exact: true }

    expect(page).to have_text("Publisher was successfully destroyed")
    expect(User.exists?(publisher.id)).to be(false)
  end

  it "creates, updates and deletes a parent STI resource" do
    visit admin_users_path
    click_link "New User", exact: true
    fill_in "First name", with: "Terry"
    fill_in "Last name", with: "Fox"
    fill_in "Username", with: "terry_fox"
    click_button "Create User"

    expect(page).to have_text("User was successfully created")
    expect(page).to have_text("Terry")
    user = User.find_by!(username: "terry_fox")
    expect(user).to have_attributes(type: nil, first_name: "Terry", last_name: "Fox")

    click_link "Edit User", exact: true
    fill_in "First name", with: "Joe"
    click_button "Update User"

    expect(page).to have_text("User was successfully updated")
    expect(page).to have_text("Joe")
    expect(user.reload).to have_attributes(type: nil, first_name: "Joe")

    accept_confirm { click_link "Delete User", exact: true }

    expect(page).to have_text("User was successfully destroyed")
    expect(User.exists?(user.id)).to be(false)
  end

  it "updates and deletes a child STI when the parent is registered" do
    publisher = Publisher.create!(first_name: "Terry", last_name: "Fox", username: "terryfox")
    visit admin_users_path
    click_link "Edit", exact: true
    fill_in "First name", with: "Joe"
    click_button "Update Publisher"

    expect(page).to have_text("Publisher was successfully updated")
    expect(page).to have_text("Joe")
    expect(publisher.reload).to have_attributes(type: "Publisher", first_name: "Joe")

    accept_confirm { click_link "Delete User", exact: true }

    expect(page).to have_text("Publisher was successfully destroyed")
    expect(User.exists?(publisher.id)).to be(false)
  end
end
