# frozen_string_literal: true
class Category < ApplicationRecord
  has_many :posts, foreign_key: :custom_category_id
  has_many :authors, through: :posts
  accepts_nested_attributes_for :posts
end
