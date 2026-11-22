# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Batch action configuration", type: :request do
  let!(:post) { Post.create!(title: "Hello World") }

  def register_posts(&block)
    register_resources { ActiveAdmin.register(Post, &block) }
  end

  it "uses the default confirmation message when confirm is true" do
    register_posts { batch_action(:flag, confirm: true) {} }

    get admin_posts_path

    action = response_html.find("[data-batch-action-item][data-action=flag]")
    expect(action["data-confirm"]).to eq("Are you sure you want to do this?")
  end

  it "omits the dropdown when every action is hidden" do
    register_posts do
      batch_action :destroy, false
      batch_action(:flag, if: proc { false }) { head :ok }
    end

    get admin_posts_path

    expect(response_html).to have_table_rows(1)
    expect(response_html).to have_no_css(".batch-actions-dropdown")
  end

  it "omits the dropdown and selection checkboxes when batch actions are disabled" do
    register_posts { config.batch_actions = false }

    get admin_posts_path

    expect(response_html).to have_table_rows(1)
    expect(response_html).to have_no_css(".batch-actions-dropdown")
    expect(response_html).to have_no_css(".paginated-collection table input[type=checkbox]")
  end

  it "can disable the default destroy action and keep custom actions" do
    register_posts do
      batch_action :destroy, false
      batch_action(:flag) {}
    end

    get admin_posts_path

    expect(response_html).to have_css("[data-batch-action-item][data-action=flag][href='#']", exact_text: "Flag Selected")
    expect(response_html).to have_no_css("[data-batch-action-item][data-action=destroy]")
  end

  it "evaluates the display condition for each action" do
    register_posts do
      batch_action(:flag, if: proc { true }) {}
      batch_action(:unflag, if: proc { false }) {}
    end

    get admin_posts_path

    expect(response_html).to have_css("[data-batch-action-item][data-action=flag][href='#']", exact_text: "Flag Selected")
    expect(response_html).to have_no_css("[data-batch-action-item][data-action=unflag]")
  end

  it "orders actions by priority" do
    register_posts do
      batch_action(:test, priority: 3) {}
      batch_action(:flag, priority: 2) {}
      batch_action(:unflag, priority: 1) {}
    end

    get admin_posts_path

    expect(response_html.all("[data-batch-action-item]").map(&:text)).to eq(
      ["Unflag Selected", "Flag Selected", "Test Selected", "Delete Selected"]
    )
  end

  it "builds action names and labels from strings and symbols" do
    register_posts do
      batch_action("Very Complex and Time Consuming") {}
      batch_action(:passing_a_symbol) {}
    end

    get admin_posts_path

    expect(response_html).to have_css("[data-batch-action-item][data-action=very_complex_and_time_consuming][href='#']", exact_text: "Very Complex and Time Consuming Selected")
    expect(response_html).to have_css("[data-batch-action-item][data-action=passing_a_symbol][href='#']", exact_text: "Passing A Symbol Selected")
  end
end
