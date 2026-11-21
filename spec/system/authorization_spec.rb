# frozen_string_literal: true
require "rails_helper"

# What a user sees when they reach something they aren't allowed to: Active
# Admin sends them back where they came from (using the Referer the browser
# sends) or, without one, to the dashboard, with the access denied message.
# The other authorization checks are request specs in
# spec/requests/authorization_spec.rb.
RSpec.describe "Access denied", type: :system do
  let!(:post_record) { Post.create!(title: "Hello World") }
  let(:denied_message) { I18n.t("active_admin.access_denied.message") }

  before { login_as_admin }

  AuthorizationAdapterHelpers::ADAPTERS.each do |adapter|
    context "with the #{adapter} adapter" do
      before do
        # Custom action items aren't filtered by authorization, so this link
        # to a denied action is shown, as it could be in a real app.
        use_authorization_adapter(adapter) do
          action_item(:edit_anyway, only: :show) do
            link_to "Edit anyway", edit_admin_post_path(resource)
          end
        end
      end

      it "sends the user back to the page they came from" do
        visit admin_posts_path
        click_on "View"
        click_on "Edit anyway"

        expect(page).to have_current_path(admin_post_path(post_record))
        expect(page).to have_page_title("Hello World")
        expect(page).to have_text(denied_message)
      end

      it "sends the user to the dashboard when they open a resource action directly" do
        visit edit_admin_post_path(post_record)

        expect(page).to have_current_path(admin_root_path)
        expect(page).to have_page_title("Dashboard")
        expect(page).to have_text(denied_message)
      end

      it "sends the user to the dashboard when they open a page directly" do
        visit admin_no_access_path

        expect(page).to have_current_path(admin_root_path)
        expect(page).to have_page_title("Dashboard")
        expect(page).to have_text(denied_message)
      end
    end
  end
end
