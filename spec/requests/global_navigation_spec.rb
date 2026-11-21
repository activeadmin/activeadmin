# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Global navigation", type: :request do
  let!(:post_record) { Post.create!(title: "Hello World") }

  before do
    register_resources { ActiveAdmin.register Post }
  end

  {
    "index" => -> { admin_posts_path },
    "new" => -> { new_admin_post_path },
    "show" => -> { admin_post_path(post_record) },
    "edit" => -> { edit_admin_post_path(post_record) }
  }.each do |page_name, path|
    it "selects the resource's menu item on the #{page_name} page" do
      get instance_exec(&path)

      expect(response).to have_http_status(:ok)
      expect(response_html).to have_css("#main-menu li a.selected", exact_text: "Posts")
    end
  end
end
