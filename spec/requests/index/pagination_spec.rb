# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index pagination", type: :request do
  def create_posts(count)
    count.times { |i| Post.create!(title: "Hello World #{i}") }
  end

  def have_page_link(text)
    have_css("[data-test-pagination] a", exact_text: text, count: 1)
  end

  it "shows all records without pagination when they fit on one page" do
    register_resources { ActiveAdmin.register(Post) }
    create_posts(20)

    get admin_posts_path

    expect(response_html).to have_text("Showing all 20")
    expect(response_html).to have_no_css("[data-test-pagination]")
  end

  it "links to each page when there's more than one" do
    register_resources { ActiveAdmin.register(Post) }
    create_posts(31)

    get admin_posts_path

    expect(response_html).to have_page_link("1")
    expect(response_html).to have_page_link("2")
  end

  it "uses a custom per_page" do
    register_resources { ActiveAdmin.register(Post) { config.per_page = 2 } }
    create_posts(3)

    get admin_posts_path

    expect(response_html).to have_page_link("1")
    expect(response_html).to have_page_link("2")
    expect(response_html).to have_text("Showing 1-2 of 3")
  end

  it "shows no pagination when it's disabled" do
    register_resources { ActiveAdmin.register(Post) { config.paginate = false } }
    create_posts(31)

    get admin_posts_path

    expect(response_html).to have_css("[data-test-page-content]")
    expect(response_html).to have_no_css("[data-test-pagination]")
  end

  it "omits the total when pagination_total is false" do
    register_resources do
      ActiveAdmin.register(Post) do
        config.per_page = 10
        index(pagination_total: false) {}
      end
    end
    create_posts(11)

    get admin_posts_path

    expect(response_html).to have_text("Showing 1-10")
    expect(response_html).to have_no_text("of 11")

    next_link = response_html.find("[data-test-pagination] a[rel=next]", text: "Next")
    get next_link[:href]

    expect(response_html).to have_text("Showing 11-11")
    expect(response_html).to have_css("[data-test-pagination]")
    expect(response_html).to have_no_css("[data-test-pagination] a[rel=next]")
  end
end
