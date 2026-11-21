# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Create another", type: :request do
  it "application config of false and a resource config of true" do
    register_resources do
      set_application_setting(:create_another, false)
      ActiveAdmin.register Post do
        config.create_another = true
      end
    end

    get new_admin_post_path

    expect(response_html).to have_css(".input-create-another")
    expect(response_html).to have_unchecked_field("Create another Post")
  end

  it "application config of true and a resource config of false" do
    register_resources do
      set_application_setting(:create_another, true)
      ActiveAdmin.register Post do
        config.create_another = false
      end
    end

    get new_admin_post_path

    expect(response_html).to have_no_css(".input-create-another")
  end
end
