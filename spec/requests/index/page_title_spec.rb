# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index page title", type: :request do
  around do |example|
    with_admin_batch_actions(false) { example.run }
  end

  context "when the title is configured as a string" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(Post) do
          index title: "Awesome Title"
        end
      end
    end

    it "renders the configured title" do
      get admin_posts_path

      expect(response).to have_http_status(:ok)
      expect(page_header_text).to eq("Awesome Title")
    end
  end

  context "when the title is configured as a proc" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(Post) do
          index title: proc { "Custom title from proc" }
        end
      end
    end

    it "renders the title returned by the proc" do
      get admin_posts_path

      expect(response).to have_http_status(:ok)
      expect(page_header_text).to eq("Custom title from proc")
    end
  end

  context "when the title proc references the resource class" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(Post) do
          index title: proc { "List of #{resource_class.model_name.plural}" }
        end
      end
    end

    it "renders the title returned by the proc" do
      get admin_posts_path

      expect(response).to have_http_status(:ok)
      expect(page_header_text).to eq("List of posts")
    end
  end

  context "when the controller sets @page_title" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(Post) do
          controller do
            before_action { @page_title = "List of #{resource_class.model_name.plural}" }
          end
        end
      end
    end

    it "renders the controller-defined title" do
      get admin_posts_path

      expect(response).to have_http_status(:ok)
      expect(page_header_text).to eq("List of posts")
    end
  end

  def with_admin_batch_actions(value)
    namespace = ActiveAdmin.application.namespace(:admin)
    previous_value = namespace.batch_actions
    namespace.batch_actions = value

    yield
  ensure
    namespace.batch_actions = previous_value
  end

  def page_header_text
    Nokogiri::HTML(response.body).at_css("[data-test-page-header] h2")&.text.to_s.squish
  end
end
