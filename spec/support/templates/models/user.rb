# frozen_string_literal: true
class User < ApplicationRecord
  class VIP < self
  end
  has_many :posts, foreign_key: "author_id"
  has_many :articles, class_name: "Post", foreign_key: "author_id"
  has_one :profile
  accepts_nested_attributes_for :profile, allow_destroy: true
  accepts_nested_attributes_for :posts, allow_destroy: true

  ransacker :age_in_five_years, type: :numeric, formatter: proc { |v| v.to_i - 5 } do |parent|
    parent.table[:age]
  end

  def display_name
    "#{first_name} #{last_name}"
  end
end
