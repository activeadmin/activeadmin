# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Batch actions", type: :system, js: true do
  let(:post_count) { 10 }
  let(:starred) { false }
  let!(:posts) do
    attributes = Array.new(post_count) { |i| { title: "Post #{i}", starred: starred } }
    inserted = Post.insert_all!(attributes, returning: %w[id])
    Post.where(id: inserted.rows.flatten).order(:id).to_a
  end

  before { login_as_admin }

  def register_posts(&block)
    register_resources { ActiveAdmin.register(Post, &block) }
  end

  def select_posts(*records)
    records.each { |post| check "batch_action_item_#{post.id}" }
  end

  it "enables the dropdown after selection and deletes only selected records" do
    register_posts

    visit admin_posts_path

    expect(page).to have_table_rows(10)
    expect(page).to have_button("Batch Actions", disabled: true)
    expect(page).to have_no_css("#batch-action-menu", visible: :visible)

    select_posts(posts[0], posts[1])
    click_button "Batch Actions"

    expect(page).to have_css("#batch-action-menu", visible: :visible)
    expect(page).to have_link("Delete Selected", exact: true)

    accept_confirm { click_link "Delete Selected", exact: true }

    expect(page).to have_text("Successfully deleted 2 posts")
    expect(page).to have_table_rows(8)
    expect(Post.order(:id).ids).to eq(posts.drop(2).map(&:id))
  end

  it "selects and clears all rows and disables the dropdown after the last selection is cleared" do
    register_posts

    visit admin_posts_path
    find(".batch-actions-toggle-all").check

    expect(page).to have_css(".batch-actions-resource-selection:checked", count: post_count)
    expect(page).to have_button("Batch Actions", disabled: false)

    find(".batch-actions-toggle-all").uncheck

    expect(page).to have_no_css(".batch-actions-resource-selection:checked")
    expect(page).to have_button("Batch Actions", disabled: true)

    select_posts(posts[0])

    expect(page).to have_button("Batch Actions", disabled: false)

    uncheck "batch_action_item_#{posts[0].id}"

    expect(page).to have_button("Batch Actions", disabled: true)
  end

  it "keeps selected records when the delete confirmation is cancelled" do
    register_posts

    visit admin_posts_path
    select_posts(posts[0], posts[1])
    click_button "Batch Actions"
    dismiss_confirm { click_link "Delete Selected", exact: true }

    expect(page).to have_table_rows(post_count)
    expect(page).to have_checked_field("batch_action_item_#{posts[0].id}")
    expect(page).to have_checked_field("batch_action_item_#{posts[1].id}")
    expect(Post.order(:id).ids).to eq(posts.map(&:id))
  end

  context "with default URL options" do
    let(:post_count) { 3 }

    it "submits the batch form with the controller's URL options" do
      register_posts do
        controller do
          protected

          def default_url_options
            { locale: I18n.locale }
          end
        end
      end

      visit admin_posts_path

      action = URI(find_by_id('collection_selection')[:action])
      expect(Rack::Utils.parse_query(action.query)).to include("locale" => "en")

      select_posts(posts[0])
      click_button "Batch Actions"
      accept_confirm { click_link "Delete Selected", exact: true }

      expect(page).to have_text("Successfully deleted 1 post")
      expect(page).to have_table_rows(2)
      expect(Post.order(:id).ids).to eq(posts.drop(1).map(&:id))
    end
  end

  { "Draper" => "PostDecorator", "PORO" => "PostPoroDecorator" }.each do |name, decorator_name|
    context "with a #{name} decorator" do
      let(:post_count) { 5 }

      it "deletes only the selected decorated records" do
        decorator = decorator_name.constantize
        register_posts { decorate_with decorator }

        visit admin_posts_path
        select_posts(posts[1], posts[3])
        click_button "Batch Actions"
        accept_confirm { click_link "Delete Selected", exact: true }

        expect(page).to have_text("Successfully deleted 2 posts")
        expect(page).to have_table_rows(3)
        expect(Post.order(:id).ids).to eq([posts[0].id, posts[2].id, posts[4].id])
      end
    end
  end

  context "with a nested resource" do
    let(:post_count) { 5 }
    let(:author) { User.create!(first_name: "John", last_name: "Doe", username: "johndoe") }

    before { posts.each { |post| post.update!(author: author) } }

    it "submits selected child records and returns to their parent's index" do
      register_resources do
        ActiveAdmin.register User
        ActiveAdmin.register(Post) { belongs_to :user }
      end

      visit admin_user_posts_path(author)

      expect(page).to have_table_rows(5)
      expect(page).to have_button("Batch Actions", disabled: true)
      expect(page).to have_no_css("#batch-action-menu", visible: :visible)

      select_posts(posts[1], posts[3])
      click_button "Batch Actions"

      expect(page).to have_css("#batch-action-menu", visible: :visible)

      accept_confirm { click_link "Delete Selected", exact: true }

      expect(page).to have_text("Successfully deleted 2 posts")
      expect(page).to have_current_path(admin_user_posts_path(author))
      expect(page).to have_table_rows(3)
      expect(author.posts.order(:id).ids).to eq([posts[0].id, posts[2].id, posts[4].id])
    end
  end

  it "submits a custom action through its dropdown link" do
    register_posts do
      batch_action :flag do |ids|
        Post.where(id: ids).update_all(starred: true)
        redirect_to collection_path, notice: "Successfully flagged 10 posts"
      end
    end

    visit admin_posts_path
    select_posts(posts[0])
    click_button "Batch Actions"
    click_link "Flag Selected", exact: true

    expect(page).to have_text("Successfully flagged 10 posts")
    expect(page).to have_table_rows(10)
    expect(Post.where(starred: true).ids).to eq([posts[0].id])
  end

  it "submits the selected records and values from a custom modal form" do
    register_posts do
      batch_action :set_starred, partial: "starred_batch_action_form",
                                 link_html_options: { "data-modal-target": "starred-batch-action-modal", "data-modal-show": "starred-batch-action-modal" } do |ids, inputs|
        if inputs["starred"] == "true"
          Post.where(id: ids).update_all(starred: true)
          redirect_to collection_path, notice: "Successfully flagged 10 posts"
        else
          redirect_to collection_path, notice: "Didn't flag any posts"
        end
      end
    end

    visit admin_posts_path
    select_posts(posts[1])
    click_button "Batch Actions"
    click_link "Set Starred Selected", exact: true

    within("#starred-batch-action-modal") do
      expect(page).to have_text("Toggle Starred")
      expect(page).to have_field("Starred", type: "checkbox")
      check "Starred"
      click_button "Submit"
    end

    expect(page).to have_text("Successfully flagged 10 posts")
    expect(page).to have_table_rows(10)
    expect(Post.where(starred: true).ids).to eq([posts[1].id])
  end

  context "when posts are starred" do
    let(:starred) { true }

    it "submits an action without asking for confirmation" do
      register_posts do
        batch_action :mark_not_starred do |ids|
          Post.where(id: ids).update_all(starred: false)
          redirect_to collection_path, notice: "#{ids.count} posts marked as not starred"
        end
      end

      visit admin_posts_path
      select_posts(posts[0], posts[2])
      click_button "Batch Actions"
      click_link "Mark Not Starred Selected", exact: true

      expect(page).to have_text("2 posts marked as not starred")
      expect(page).to have_table_rows(10)
      expect(Post.where(starred: false).order(:id).ids).to eq([posts[0].id, posts[2].id])
    end
  end
end
