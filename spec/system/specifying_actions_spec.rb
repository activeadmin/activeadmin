# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Specifying actions", type: :system do
  before { login_as_admin }

  context "with a custom collection action that has a template" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register Post do
          action_item(:import, only: :index) do
            link_to("Import Posts", import_admin_posts_path)
          end

          collection_action :import
        end
      end
    end

    before do
      write_view "admin/posts/import.html.arb", 'para "We are currently working on this feature..."'
    end

    it "renders the template" do
      visit admin_posts_path
      click_on "Import"

      expect(page).to have_text("We are currently working on this feature")
    end
  end

  context "with a custom member action that has a template" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register Post do
          action_item(:review, only: :show) do
            link_to("Review", review_admin_post_path)
          end

          member_action :review do
            @post = Post.find(params[:id])
          end
        end
      end
    end

    before { Post.create!(title: "Hello World") }

    {
      "ERB" => ["review.html.erb", "<h1>Review: <%= @post.title %></h1>"],
      "Arbre" => ["review.html.arb", 'h1 "Review: #{post.title}"']
    }.each do |language, (filename, template)|
      it "renders an #{language} template" do
        write_view "admin/posts/#{filename}", template

        visit admin_posts_path
        click_on "View"
        click_on "Review"

        expect(page).to have_text("Review: Hello World")
        within("[data-test-page-header]") { expect(page).to have_text("Review") }
      end
    end
  end
end
