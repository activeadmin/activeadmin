# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Action items", type: :system do
  before do
    login_as_admin
    Post.create!(title: "Hello World")
  end

  def expect_action_item_on_show_edit_and_new(visible:)
    matcher = visible ? :have_css : :have_no_css

    visit admin_posts_path
    expect(page).to have_css(".data-table-resource-actions > a", text: "View")
    expect(page).to have_no_css(".data-table-resource-actions > a", text: "Embiggen")

    click_on "View"
    expect(page).to send(matcher, "[data-test-action-items] > a", text: "Embiggen")

    click_on "Edit Post"
    expect(page).to send(matcher, "[data-test-action-items] > a", text: "Embiggen")

    visit admin_posts_path
    click_on "New Post"
    expect(page).to send(matcher, "[data-test-action-items] > a", text: "Embiggen")
  end

  context "with a member action item" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register Post do
          action_item :embiggen do
            link_to "Embiggen", "/"
          end
        end
      end
    end

    it "shows it on show, edit and new pages but not as an index member link" do
      expect_action_item_on_show_edit_and_new(visible: true)
    end
  end

  context "with an if clause that returns true" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register Post do
          action_item :embiggen, if: proc { !current_active_admin_user.nil? } do
            link_to "Embiggen", "/"
          end
        end
      end
    end

    it "shows it on show, edit and new pages" do
      expect_action_item_on_show_edit_and_new(visible: true)
    end
  end

  context "with an if clause that returns false" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register Post do
          action_item :embiggen, if: proc { current_active_admin_user.nil? } do
            link_to "Embiggen", "/"
          end
        end
      end
    end

    it "hides it on show, edit and new pages" do
      expect_action_item_on_show_edit_and_new(visible: false)
    end
  end
end
