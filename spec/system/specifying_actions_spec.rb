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
        expect(page).to have_page_title("Review")
      end
    end
  end

  it "calls a custom member action with multiple http methods", js: true do
    register_resources do
      ActiveAdmin.register Post do
        action_item(:get_check, only: :show) do
          link_to('Get Check', check_admin_post_path)
        end

        action_item(:post_check, only: :show) do
          link_to('Post Check', check_admin_post_path, method: :post)
        end

        member_action :check, method: [:get, :post] do
          redirect_to admin_post_path(resource), notice: "Checked via #{request.method}"
        end
      end
    end
    login_as_admin
    Post.create!(title: "Hello World", starred: nil)
    visit admin_posts_path
    click_link "View", exact: true
    click_link "Get Check", exact: true

    expect(page).to have_text("Checked via GET")

    click_link "Post Check", exact: true

    expect(page).to have_text("Checked via POST")
  end
end
