# frozen_string_literal: true
class Blog::Post < ApplicationRecord
  belongs_to :category, foreign_key: :custom_category_id
  belongs_to :author, class_name: "User"
  has_many :taggings
  accepts_nested_attributes_for :author
  accepts_nested_attributes_for :taggings, allow_destroy: true
end
