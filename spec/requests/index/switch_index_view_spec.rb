# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Switching index views", type: :request do
  let(:custom_index_view) do
    Class.new(ActiveAdmin::Component) do
      def build(page_presenter, collection)
        add_class "custom-index-view"
        resource_selection_toggle_panel if active_admin_config.batch_actions.any?
        collection.each do |obj|
          instance_exec(obj, &page_presenter.block)
        end
      end

      def self.index_name
        "custom"
      end
    end
  end

  before do
    Post.create!(title: "Hello World from Table", starred: nil)
  end

  it "uses the default page presenter" do
    view_class = custom_index_view
    register_resources do
      ActiveAdmin.register Post do
        index do
          column :title
        end
        index as: view_class do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_css(".index-as-table", text: "Hello World from Table")
  end

  it "links to each page view" do
    view_class = custom_index_view
    register_resources do
      ActiveAdmin.register Post do
        index as: view_class do |post|
          span(link_to(post.title, admin_post_path(post)))
        end
        index default: true do
          column :title
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_css(".index-as-table", text: "Hello World from Table")
    expect(response_html).to have_link("Table", exact: true)
    expect(response_html).to have_link("Custom", exact: true)

    get response_html.find_link("Custom", exact: true)[:href]

    expect(response_html).to have_css(".custom-index-view", text: "Hello World from Table")
  end
end
