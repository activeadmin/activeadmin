# frozen_string_literal: true
require "rails_helper"
require "csv"

RSpec.describe "Scoped exports and batch actions", type: :request do
  let(:owner) { User.create!(first_name: "Jane", last_name: "Doe", username: "scope_owner") }
  let(:other_owner) { User.create!(first_name: "John", last_name: "Doe", username: "other_owner") }
  let!(:visible_post) { Post.create!(title: "Visible post", author: owner) }
  let!(:hidden_post) { Post.create!(title: "Hidden post", author: other_owner) }

  before do
    register_resources do
      ActiveAdmin.register Post do
        scope_to { User.find_by!(username: "scope_owner") }
        csv { column :title }
      end
    end
  end

  it "exports only records within the resource scope" do
    get admin_posts_path(format: :csv)

    expect(response).to have_http_status(:ok)
    rows = CSV.parse(response.body.delete_prefix("\uFEFF"))
    expect(rows).to eq([["Title"], [visible_post.title]])
  end

  it "deletes selected records within the scope and leaves other records alone" do
    post batch_action_admin_posts_path,
         params: { batch_action: "destroy", collection_selection: [visible_post.id] }

    expect(response).to redirect_to(admin_posts_path)
    expect(Post.exists?(visible_post.id)).to be(false)
    expect(Post.exists?(hidden_post.id)).to be(true)
  end

  it "rejects a selection outside the scope without deleting it" do
    expect do
      post batch_action_admin_posts_path,
           params: { batch_action: "destroy", collection_selection: [hidden_post.id] }
    end.not_to change(Post, :count)

    expect(response).to have_http_status(:not_found)
    expect(Post.exists?(hidden_post.id)).to be(true)
  end

  it "rejects a mixed selection before deleting any records" do
    expect do
      post batch_action_admin_posts_path,
           params: { batch_action: "destroy", collection_selection: [visible_post.id, hidden_post.id] }
    end.not_to change(Post, :count)

    expect(response).to have_http_status(:not_found)
    expect(Post.order(:id).ids).to eq([visible_post.id, hidden_post.id])
  end
end
