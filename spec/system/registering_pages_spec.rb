# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Registering pages", type: :system do
  before { login_as_admin }

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
