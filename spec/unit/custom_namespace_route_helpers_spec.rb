# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Custom Namespace Route Helpers" do
  let(:application) { ActiveAdmin::Application.new }

  around do |example|
    original_application = ActiveAdmin.application
    ActiveAdmin.application = application
    application.default_namespace = :active_admin

    load_resources do
      ActiveAdmin.register(Post, namespace: :active_admin)
    end

    example.call
  ensure
    ActiveAdmin.application = original_application
    application.namespaces.instance_variable_get(:@namespaces).delete(:active_admin)
  end

  it "should have route helpers available in Helpers::Routes" do
    expect(ActiveAdmin::Helpers::Routes).to respond_to(:active_admin_posts_path)
    expect(ActiveAdmin::Helpers::Routes).to respond_to(:active_admin_post_path)
    expect(ActiveAdmin::Helpers::Routes).to respond_to(:new_active_admin_post_path)
    expect(ActiveAdmin::Helpers::Routes).to respond_to(:edit_active_admin_post_path)
  end

  it "should generate correct paths via route helpers" do
    expect(ActiveAdmin::Helpers::Routes.active_admin_posts_path).to eq "/active_admin/posts"
    expect(ActiveAdmin::Helpers::Routes.new_active_admin_post_path).to eq "/active_admin/posts/new"
  end

  it "should generate correct paths for instance routes" do
    post = Post.new { |p| p.id = 123 }
    expect(ActiveAdmin::Helpers::Routes.active_admin_post_path(123)).to eq "/active_admin/posts/123"
    expect(ActiveAdmin::Helpers::Routes.edit_active_admin_post_path(123)).to eq "/active_admin/posts/123/edit"
  end

  it "should work from resource route_instance_path" do
    post = Post.new { |p| p.id = 123 }
    resource = application.namespace(:active_admin).resource_for("Post")
    expect(resource.route_instance_path(post)).to eq "/active_admin/posts/123"
  end
end
