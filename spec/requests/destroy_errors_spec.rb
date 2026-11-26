# frozen_string_literal: true
require "rails_helper"

class CategoryRestrictedWithError < ActiveRecord::Base
  self.table_name = "categories"
  has_many :posts, foreign_key: :custom_category_id, dependent: :restrict_with_error
end

class CategoryRestrictedWithException < ActiveRecord::Base
  self.table_name = "categories"
  has_many :posts, foreign_key: :custom_category_id, dependent: :restrict_with_exception
end

RSpec.describe "Destroying a resource that cannot be destroyed", type: :request do
  around do |example|
    with_resources_during(example) do
      ActiveAdmin.register CategoryRestrictedWithError
      ActiveAdmin.register CategoryRestrictedWithException
    end
  end

  def destroy_category(model)
    category = model.create!(name: "News")
    Post.create!(title: "Hello", custom_category_id: category.id)

    delete "/admin/#{model.model_name.route_key}/#{category.id}"
    category
  end

  it "shows the record's errors when destroy returns false" do
    category = destroy_category(CategoryRestrictedWithError)

    expect(response).to redirect_to("/admin/category_restricted_with_errors")
    expect(flash[:alert]).to eq "Category restricted with error could not be destroyed. Cannot delete record because dependent posts exist"
    expect(CategoryRestrictedWithError.exists?(category.id)).to be true
  end

  it "shows the restriction instead of failing when destroy raises DeleteRestrictionError" do
    category = destroy_category(CategoryRestrictedWithException)

    expect(response).to redirect_to("/admin/category_restricted_with_exceptions")
    expect(flash[:alert]).to eq "Category restricted with exception could not be destroyed. Cannot delete record because of dependent posts"
    expect(CategoryRestrictedWithException.exists?(category.id)).to be true
  end

  it "leaves the batch delete raising DeleteRestrictionError" do
    category = CategoryRestrictedWithException.create!(name: "News")
    Post.create!(title: "Hello", custom_category_id: category.id)

    expect do
      post "/admin/category_restricted_with_exceptions/batch_action",
           params: { batch_action: "destroy", collection_selection: [category.id] }
    end.to raise_error(ActiveRecord::DeleteRestrictionError)
  end

  it "keeps the success notice when destroy succeeds" do
    category = CategoryRestrictedWithError.create!(name: "Empty")

    delete "/admin/category_restricted_with_errors/#{category.id}"

    expect(flash[:notice]).to eq "Category restricted with error was successfully destroyed."
    expect(flash[:alert]).to be_nil
  end
end
