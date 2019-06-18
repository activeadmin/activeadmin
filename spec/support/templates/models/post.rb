class Post < ActiveRecord::Base
  belongs_to :category, foreign_key: :custom_category_id, optional: true
  belongs_to :author, class_name: 'User', optional: true
  has_many :taggings
  has_many :tags, through: :taggings
  accepts_nested_attributes_for :author
  accepts_nested_attributes_for :taggings, allow_destroy: true

  ransacker :custom_title_searcher do |parent|
    parent.table[:title]
  end

  ransacker :custom_created_at_searcher do |parent|
    parent.table[:created_at]
  end

  ransacker :custom_searcher_numeric, type: :numeric do
    # nothing to see here
  end
end
