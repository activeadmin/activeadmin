class AddAuthorIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :author_id, :integer
  end

  def self.down
    remove_column :posts, :author_id
  end
end
