# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index blank slate", type: :request do
  # The blank slate has no class or data attribute of its own, so find it
  # as the element around its message.
  def blank_slate
    response_html.find("h2", exact_text: "There are no Posts yet.", normalize_ws: true).find(:xpath, "..")
  end

  it "shows a message and a link to create one instead of a table" do
    register_resources do
      ActiveAdmin.register Post do
        batch_action(:favourite) {}
        scope :all, default: true
      end
    end

    get admin_posts_path

    expect(blank_slate).to have_text("There are no Posts yet.")
    expect(blank_slate).to have_link("Create one", href: new_admin_post_path)
    expect(response_html).to have_no_css("th[data-sortable]")
    expect(response_html).to have_no_css(".data-table")
    expect(response_html).to have_no_css("[data-test-pagination]")
  end

  it "has no create link when there's no new action" do
    register_resources { ActiveAdmin.register(Post) { actions :index, :show } }

    get admin_posts_path

    expect(blank_slate).to have_text("There are no Posts yet.")
    expect(blank_slate).to have_no_link("Create one")
  end

  it "uses a custom link" do
    load_default_resources do
      ActiveAdmin.register Post do
        index(blank_slate_link: -> { link_to("Go to dashboard", admin_root_path) }) { |post| }
      end
    end

    get admin_posts_path

    link = blank_slate.find_link("Go to dashboard")
    get link[:href]

    expect(response_html).to have_page_title("Dashboard")
  end

  it "has no link with blank_slate_link: false" do
    register_resources do
      ActiveAdmin.register(Post) { index(blank_slate_link: false) { |post| } }
    end

    get admin_posts_path

    expect(blank_slate).to have_text("There are no Posts yet.")
    expect(blank_slate).to have_no_link
  end
end
