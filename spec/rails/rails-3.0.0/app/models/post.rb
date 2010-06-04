class Post < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  accepts_nested_attributes_for :author
end
