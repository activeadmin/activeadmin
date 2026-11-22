# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Registering pages", type: :system do
  before { login_as_admin }

  it "calls a page action through GET and POST links", js: true do
    register_resources do
      ActiveAdmin.register_page "Status" do
        page_action :check, method: [:get, :post] do
          redirect_to admin_status_path, notice: "Checked via #{request.method}"
        end

        action_item :post_check do
          link_to "Post Check", admin_status_check_path, method: :post
        end

        action_item :get_check do
          link_to "Get Check", admin_status_check_path
        end

        content do
          "I love chocolate."
        end
      end
    end

    visit admin_root_path
    click_link "Status", exact: true
    click_link "Post Check", exact: true

    expect(page).to have_current_path(admin_status_path)
    expect(page).to have_text("Checked via POST")

    click_link "Get Check", exact: true

    expect(page).to have_current_path(admin_status_path)
    expect(page).to have_text("Checked via GET")
  end

  context "with a page action that has an ERB view" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register_page "Status" do
          page_action :check do
          end

          content do
            ("Chocolate I lØve You!" + link_to("Check", admin_status_check_path)).html_safe
          end
        end
      end
    end

    before do
      write_view "admin/status/check.html.erb", "<div>Chocolate lØves You Too!</div>"
    end

    it "renders the view" do
      visit admin_root_path
      click_on "Status"
      click_on "Check"

      expect(page).to have_css("[data-test-page-content]", text: "Chocolate lØves You Too!")
    end
  end
end
