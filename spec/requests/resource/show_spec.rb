# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Resource show page", type: :request do
  let!(:application) { ActiveAdmin::Application.new }
  let!(:namespace) { application.namespace(:admin) }
  let(:html_body) { Capybara.string(response.body) }

  context "with no display name" do
    let!(:post) { Post.create! }
    let(:resource) do
      namespace.register Post do
        show do |post|
          attributes_table do
            row :field
          end
        end
      end
    end

    it "renders default page title" do
      with_temp_application(application) do
        load_resources { resource }

        get admin_post_path(post)

        expect(response.body).to include("Post ##{post.id}")
        expect(html_body).to have_css("[data-test-page-header]", text: "Post ##{post.id}")
      end
    end
  end
end
