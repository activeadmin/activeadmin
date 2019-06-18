class Tagging < ActiveRecord::Base
  belongs_to :post, optional: true
  belongs_to :tag, optional: true

  delegate :name, to: :tag, prefix: true
end
