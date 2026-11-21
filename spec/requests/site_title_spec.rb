# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Site title", type: :request do
  def have_site_title(title)
    have_css("[data-test-site-title]", exact_text: title, normalize_ws: true)
  end

  it "uses a string" do
    set_application_setting(:site_title, "My Great Site")
    load_default_resources

    get admin_root_path

    expect(response_html).to have_site_title("My Great Site")
  end

  it "uses a proc, which can call the controller" do
    login_as_admin
    set_application_setting(:site_title, proc { "Hello #{controller.current_admin_user.try(:email) || 'you!'}" })
    load_default_resources

    get admin_root_path

    expect(response_html).to have_site_title("Hello admin@example.com")
  end

  it "uses a namespace's own title in that namespace" do
    set_application_setting(:site_title, "My Great Site")
    load_default_resources do
      ActiveAdmin.application.namespace(:superadmin).site_title = "Namespace Site Title"
      ActiveAdmin.register AdminUser, namespace: :superadmin
    end

    get superadmin_admin_users_path

    expect(response_html).to have_site_title("Namespace Site Title")

    get admin_root_path

    expect(response_html).to have_site_title("My Great Site")
  end
end
