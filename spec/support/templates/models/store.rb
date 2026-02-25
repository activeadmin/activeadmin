# frozen_string_literal: true
class Store < ApplicationRecord
  enum :review_status, [:pending, :approved, :rejected]
  enum :reject_reason, {
    not_a_good_fit: 0,
    other: 10
  }
end
