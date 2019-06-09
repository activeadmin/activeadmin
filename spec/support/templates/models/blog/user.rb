class Blog::User < ActiveRecord::Base
  has_many :posts, foreign_key: 'author_id'

  def display_name
    "#{first_name} #{last_name}"
  end
end
