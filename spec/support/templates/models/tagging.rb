# frozen_string_literal: true
class Tagging < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :tag, optional: true

  delegate :name, to: :tag, prefix: true
end
