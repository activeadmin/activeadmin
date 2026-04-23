# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Resource registration", type: :request do
  let!(:post_record) { Post.create!(title: "Hello World") }

  # Fixes failure with: bin/rspec spec/requests --seed 19664
  around do |example|
    with_admin_batch_actions(false) { example.run }
  end

  context "when registering a resource with the defaults" do
    around do |example|
      with_resources_during(example) { ActiveAdmin.register(Post) }
    end

    it "renders the resource in the dashboard, index, and show pages" do
      resource = ActiveAdmin.application.namespace(:admin).resource_for(Post)

      get admin_root_path
      expect(response).to have_http_status(:ok)
      expect(html_body).to have_link("Posts", href: resource.route_collection_path)

      get resource.route_collection_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello World")
      expect(html_body).to have_link("View", href: resource.route_instance_path(post_record))

      get resource.route_instance_path(post_record)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello World")
      expect(resource.route_instance_path(post_record)).to include("posts")
    end
  end

  context "when registering a resource with another name" do
    around do |example|
      with_resources_during(example) { ActiveAdmin.register(Post, as: "My Post") }
    end

    it "uses the aliased resource name and routes" do
      resource = ActiveAdmin.application.namespace(:admin).resource_for(Post)

      get admin_root_path
      expect(response).to have_http_status(:ok)
      expect(html_body).to have_link("My Posts", href: resource.route_collection_path)

      get resource.route_collection_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello World")
      expect(html_body).to have_link("View", href: resource.route_instance_path(post_record))

      get resource.route_instance_path(post_record)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello World")
      expect(resource.route_instance_path(post_record)).to include("my_posts")
    end
  end

  private

  def with_admin_batch_actions(value)
    namespace = ActiveAdmin.application.namespace(:admin)
    previous_value = namespace.batch_actions
    namespace.batch_actions = value

    yield
  ensure
    namespace.batch_actions = previous_value
  end

  def html_body
    Capybara.string(response.body)
  end
end
