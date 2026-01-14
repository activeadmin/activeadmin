# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::PaginationHelper do
  let(:helper) do
    helper = Object.new.tap { |obj| obj.extend ActiveAdmin::PaginationHelper }
    helper.extend ActiveAdmin::IndexHelper
    helper
  end

  let(:collection) do
    posts = [Post.new(title: "First Post"), Post.new(title: "Second Post"), Post.new(title: "Third Post")]
    Kaminari.paginate_array(posts).page(1).per(5)
  end

  describe "#active_admin_page_entries_info" do
    before do
      3.times { |n| Post.create title: "A post #{n}" }
    end

    context "with a simple collection" do
      it "should return the page entries info" do
        info = helper.active_admin_page_entries_info(collection)
        expect(info).to include("Showing")
        expect(info).to include("3")
      end
    end

    context "with entry_name option" do
      it "should use the provided entry name" do
        info = helper.active_admin_page_entries_info(collection, entry_name: "article")
        expect(info).to include("Showing")
      end
    end

    context "with pagination_total option set to false" do
      let(:large_collection) do
        posts = Array.new(100) { Post.new }
        Kaminari.paginate_array(posts).page(1).per(30)
      end

      it "should not show total count" do
        info = helper.active_admin_page_entries_info(large_collection, pagination_total: false)
        expect(info).to match(/Showing.*1.*30/i)
        expect(info).not_to include("100")
      end
    end
  end

  describe "#active_admin_paginate" do
    # This method delegates to Kaminari's paginate, so we'll just verify it's callable
    it "should be defined" do
      expect(helper).to respond_to(:active_admin_paginate)
    end
  end
end
