# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index page title", type: :request do
  def register_post_index(&block)
    register_resources { ActiveAdmin.register(Post, &block) }
  end

  it "uses a string" do
    register_post_index { index title: "Awesome Title" }

    get admin_posts_path

    expect(response_html).to have_page_title("Awesome Title")
  end

  it "uses a proc" do
    register_post_index { index title: proc { "Custom title from proc" } }

    get admin_posts_path

    expect(response_html).to have_page_title("Custom title from proc")
  end

  it "uses a proc that calls resource_class" do
    register_post_index { index title: proc { "List of #{resource_class.model_name.plural}" } }

    get admin_posts_path

    expect(response_html).to have_page_title("List of posts")
  end

  it "uses @page_title set in the controller" do
    register_post_index do
      controller do
        before_action { @page_title = "List of #{resource_class.model_name.plural}" }
      end
    end

    get admin_posts_path

    expect(response_html).to have_page_title("List of posts")
  end
end
