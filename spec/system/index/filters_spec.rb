# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index filters", type: :system do
  let(:author) { User.create!(first_name: "Jane", last_name: "Doe", username: "janedoe") }
  let(:category) { Category.create!(name: "Non-Fiction") }
  let(:post) { Post.create!(title: "Hello World", author: author, category: category) }

  before { login_as_admin }

  def register_posts(&block)
    register_resources { ActiveAdmin.register(Post, &block) }
  end

  def expect_current_filter(name, value, label: nil)
    selector = ".active-filters [data-filter='#{name}']"
    expect(page).to have_css("#{selector} strong", exact_text: value, normalize_ws: true)
    expect(page).to have_css(selector, exact_text: "#{label} #{value}", normalize_ws: true) if label
  end

  it "renders default filter types and submits a title filter" do
    3.times { |i| Post.create!(title: "Hello World #{i}") }
    register_posts

    visit admin_posts_path

    expect(page).to have_text("Showing all 3")
    {
      "Author" => "select", "Category" => "select", "Title" => "string", "Body" => "string",
      "Published date" => "date_range", "Created at" => "date_range", "Updated at" => "date_range"
    }.each do |label, type|
      expect(page).to have_css(".filters-form-field.#{type} label", exact_text: label)
    end

    fill_in "Title", with: "Hello World 2"
    click_button "Filter"

    expect(page).to have_table_rows(1)
    expect(page).to have_css(".data-table td", exact_text: "Hello World 2")
    expect_current_filter("title_cont", "Hello World 2", label: "Title contains")
  end

  it "changes the predicate and submits the matching query parameter", js: true do
    Post.create!(title: "Alpha")
    Post.create!(title: "Alpha Beta")
    Post.create!(title: "Beta Alpha")
    register_posts { filter :title }

    visit admin_posts_path
    find("[data-search-methods]").select("Equals")
    fill_in "Title", with: "Alpha"
    click_button "Filter"

    expect(page).to have_table_rows(1)
    expect(page).to have_css(".data-table td", exact_text: "Alpha")
    expect_current_filter("title_eq", "Alpha", label: "Title equals")
    params = Rack::Utils.parse_nested_query(URI(page.current_url).query)
    expect(params.fetch("q")).to eq("title_eq" => "Alpha")

    find("[data-search-methods]").select("Starts with")
    click_button "Filter"

    expect(page).to have_table_rows(2)
    expect(page).to have_css(".data-table td", exact_text: "Alpha")
    expect(page).to have_css(".data-table td", exact_text: "Alpha Beta")
    expect(page).to have_no_css(".data-table td", exact_text: "Beta Alpha")
    expect_current_filter("title_start", "Alpha", label: "Title starts with")
    params = Rack::Utils.parse_nested_query(URI(page.current_url).query)
    expect(params.fetch("q")).to eq("title_start" => "Alpha")
  end

  it "escapes the submitted value in the active filter" do
    register_posts { filter :title }

    visit admin_posts_path
    fill_in "Title", with: "<script>alert('hack')</script>"
    click_button "Filter"

    expect_current_filter("title_cont", "<script>alert('hack')</script>", label: "Title contains")
    expect(page).to have_no_css(".active-filters script", visible: :all)
  end

  it "omits the result table, sortable headers and pagination when nothing matches" do
    3.times { |i| Post.create!(title: "Hello World #{i}") }
    register_posts

    visit admin_posts_path

    expect(page).to have_text("Showing all 3")

    fill_in "Title", with: "THIS IS NOT AN EXISTING TITLE!!"
    click_button "Filter"

    expect(page).to have_text("No Posts found")
    expect(page).to have_no_css(".data-table")
    expect(page).to have_no_css("th[data-sortable]")
    expect(page).to have_no_css("[data-test-pagination]")
  end

  it "keeps the filter when moving through result pages" do
    7.times { Post.create!(title: "Hello World 3") }
    Post.create!(title: "Hello World 4")
    register_posts { config.per_page = 2 }

    visit admin_posts_path
    fill_in "Title", with: "Hello World 3"
    click_button "Filter"
    within("[data-test-pagination]") { click_link "2", exact: true }

    expect(page).to have_text("Showing 3-4 of 7")
    expect(page).to have_table_rows(2)
    expect_current_filter("title_cont", "Hello World 3", label: "Title contains")

    within("[data-test-pagination]") { click_link "3", exact: true }

    expect(page).to have_text("Showing 5-6 of 7")
    expect(page).to have_table_rows(2)
    expect(page).to have_no_text("Hello World 4")
  end

  it "returns to the first result page when filtering from another page" do
    9.times { |i| Post.create!(title: "Hello World #{i}") }
    register_posts { config.per_page = 5 }

    visit admin_posts_path
    within("[data-test-pagination]") { click_link "2", exact: true }

    expect(page).to have_text("Showing 6-9 of 9")

    fill_in "Title", with: "Hello World 2"
    click_button "Filter"

    expect(page).to have_table_rows(1)
    expect(page).to have_css(".data-table td", exact_text: "Hello World 2")
  end

  context "with author checkboxes" do
    let!(:authored_post) { post }
    let!(:other_post) { Post.create!(title: "Another post") }

    before { register_posts { filter :author, as: :check_boxes } }

    it "keeps all posts when no author is selected" do
      visit admin_posts_path
      click_button "Filter"

      expect(page).to have_table_rows(2)
      expect(page).to have_css(".data-table td", exact_text: authored_post.title)
      expect(page).to have_unchecked_field("Jane Doe")
    end

    it "filters by the selected author" do
      visit admin_posts_path
      check "Jane Doe"
      click_button "Filter"

      expect(page).to have_table_rows(1)
      expect(page).to have_css(".data-table td", exact_text: authored_post.title)
      expect(page).to have_no_css(".data-table td", exact_text: other_post.title)
      expect(page).to have_checked_field("Jane Doe")
      expect_current_filter("author_id_in", "Jane Doe")
    end
  end

  context "with categories" do
    let!(:authored_post) { post }
    let!(:other_category) { Category.create!(name: "Mystery") }

    it "filters categories by their posts' author using a select" do
      register_resources { ActiveAdmin.register Category }

      visit admin_categories_path
      select "Jane Doe", from: "Authors"
      click_button "Filter"

      expect(page).to have_table_rows(1)
      expect(page).to have_css(".data-table td", exact_text: category.name)
      expect(page).to have_no_css(".data-table td", exact_text: other_category.name)
      expect_current_filter("posts_author_id_eq", "Jane Doe")
    end

    it "clears filters while preserving custom parameters", js: true do
      other_author = User.create!(first_name: "Joe", last_name: "Smith", username: "joesmith")
      Post.create!(title: "Lorem Ipsum", author: other_author, category: other_category)
      register_resources { ActiveAdmin.register Category }

      visit admin_categories_path(scope: "all", foo: "bar")

      expect(page).to have_text("Showing all 2")

      select authored_post.title, from: "Posts"
      click_button "Filter"

      expect(page).to have_table_rows(1)
      expect(page).to have_css(".data-table td", exact_text: category.name)
      expect(page).to have_no_css(".data-table td", exact_text: other_category.name)

      click_link "Clear Filters", exact: true

      expect(page).to have_table_rows(2)
      expect(page).to have_css(".data-table td", exact_text: category.name)
      expect(page).to have_css(".data-table td", exact_text: other_category.name)
      params = Rack::Utils.parse_nested_query(URI(page.current_url).query)
      expect(params).to include("foo" => "bar", "scope" => "all")
      expect(params.keys).not_to include("q", "page", "utf8", "commit")
    end

    context "with author checkboxes" do
      before do
        register_resources { ActiveAdmin.register(Category) { filter :authors, as: :check_boxes } }
      end

      it "keeps all categories when no author is selected" do
        visit admin_categories_path
        click_button "Filter"

        expect(page).to have_table_rows(2)
        expect(page).to have_css(".data-table td", exact_text: category.name)
        expect(page).to have_css(".data-table td", exact_text: other_category.name)
        expect(page).to have_unchecked_field("Jane Doe")
        expect(page).to have_no_text("Active Search")
      end

      it "filters categories by the selected author" do
        visit admin_categories_path
        check "Jane Doe"
        click_button "Filter"

        expect(page).to have_table_rows(1)
        expect(page).to have_css(".data-table td", exact_text: category.name)
        expect(page).to have_no_css(".data-table td", exact_text: other_category.name)
        expect(page).to have_checked_field("Jane Doe")
      end
    end

    it "links the selected category in the active filter" do
      register_resources do
        ActiveAdmin.register Category
        ActiveAdmin.register(Post) { filter :category }
      end

      visit admin_posts_path
      select category.name, from: "Category"
      click_button "Filter"

      expect(page).to have_text("Active Search")
      expect(page).to have_css(".active-filters [data-filter] strong a", exact_text: category.name)
    end
  end

  it "filters when no default scope is set" do
    post
    register_posts do
      scope :all
      scope(:published) { |posts| posts.where.not(published_date: nil) }
      filter :title
    end

    visit admin_posts_path
    fill_in "Title", with: "Hello"
    click_button "Filter"

    expect_current_filter("title_cont", "Hello", label: "Title contains")
    expect(page).to have_table_rows(1)
  end

  it "lets a resource enable active filters when disabled at application level" do
    set_application_setting(:current_filters, false)
    register_posts { config.current_filters = true }

    visit admin_posts_path
    click_button "Filter"

    expect(page).to have_text("Active Search")
  end

  it "lets a resource disable active filters when enabled at application level" do
    set_application_setting(:current_filters, true)
    register_posts { config.current_filters = false }

    visit admin_posts_path
    click_button "Filter"

    expect(page).to have_page_title("Posts")
    expect(page).to have_no_text("Active Search")
  end

  it "filters parents by a nested resource" do
    nested_post = Post.create!(title: "The arrogant president", author: author)
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        permit_params :user_id
        belongs_to :author, class_name: "User"
      end
    end

    visit admin_users_path
    select nested_post.title, from: "Posts"
    click_button "Filter"

    expect(page).to have_table_rows(1)
    expect(page).to have_css(".data-table td", exact_text: author.first_name)
  end

  context "with association size limits" do
    let!(:astrology) { Category.create!(name: "Astrology") }
    let!(:astronomy) { Category.create!(name: "Astronomy") }
    let!(:navigation) { Category.create!(name: "Navigation") }
    let!(:star_signs) { Post.create!(title: "Star Signs", category: astrology) }
    let!(:constellations) { Post.create!(title: "Constellations", category: astronomy) }
    let!(:compass) { Post.create!(title: "Compass and Sextant", category: navigation) }

    def register_association_filters(maximum:, predicate: "_start")
      set_namespace_setting(:admin, :maximum_association_filter_arity, maximum)
      set_namespace_setting(:admin, :filter_method_for_large_association, predicate)
      register_resources do
        ActiveAdmin.register Category
        ActiveAdmin.register Post
      end
    end

    it "switches filter types at the limit and supports a custom search predicate" do
      register_association_filters(maximum: 3)
      visit admin_posts_path

      expect(page).to have_select("Category")
      expect(page).to have_no_field("Category name start")

      register_association_filters(maximum: 2)
      visit admin_posts_path
      fill_in "Category name start", with: "Astro"
      click_button "Filter"

      expect(page).to have_table_rows(2)
      expect(page).to have_text(star_signs.title)
      expect(page).to have_text(constellations.title)
      expect(page).to have_no_text(compass.title)

      register_association_filters(maximum: 2, predicate: "_cont")
      visit admin_posts_path
      fill_in "Category name cont", with: "Astro"
      click_button "Filter"

      expect(page).to have_table_rows(2)
      expect(page).to have_text(star_signs.title)
      expect(page).to have_text(constellations.title)
      expect(page).to have_no_text(compass.title)

      register_association_filters(maximum: :unlimited, predicate: "_cont")
      visit admin_posts_path
      select astronomy.name, from: "Category"
      click_button "Filter"

      expect(page).to have_table_rows(1)
      expect(page).to have_text(constellations.title)
      expect(page).to have_no_text(star_signs.title)
      expect(page).to have_no_text(compass.title)

      register_association_filters(maximum: :unlimited)
      visit admin_posts_path

      expect(page).to have_select("Category")
      expect(page).to have_no_field("Category name start")
    end
  end

  it "filters through a custom Ransack scope" do
    unstarred = Post.create!(title: "Hello World", author: author, starred: false)
    starred = Post.create!(title: "Starred World", author: author, starred: true)
    register_posts do
      filter :fancy_filter, label: "Ransackable Custom Filter", as: :select, collection: ["Starred", "Not Starred"]
    end

    visit admin_posts_path
    select "Starred", from: "Ransackable Custom Filter"
    click_button "Filter"

    expect_current_filter("fancy_filter", "Starred", label: "Ransackable Custom Filter equals")
    expect(page).to have_css(".data-table td", exact_text: starred.title)
    expect(page).to have_no_css(".data-table td", exact_text: unstarred.title)

    select "Not Starred", from: "Ransackable Custom Filter"
    click_button "Filter"

    expect_current_filter("fancy_filter", "Not Starred", label: "Ransackable Custom Filter equals")
    expect(page).to have_css(".data-table td", exact_text: unstarred.title)
    expect(page).to have_no_css(".data-table td", exact_text: starred.title)
  end

  it "keeps a counter-like attribute available as a numeric filter" do
    author
    register_resources { ActiveAdmin.register User }

    visit admin_users_path

    expect(page).to have_text("Showing 1 of 1")
    expect(page).to have_css(".filters-form-field.numeric label", exact_text: "Sign in count")

    fill_in "Sign in count", with: "0"
    click_button "Filter"

    expect(page).to have_table_rows(1)

    fill_in "Sign in count", with: "1"
    click_button "Filter"

    expect(page).to have_text("No Users found")
  end
end
