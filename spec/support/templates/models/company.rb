# frozen_string_literal: true
class Company < ApplicationRecord
  has_and_belongs_to_many :stores

  validates :name, presence: true
end
