class CreateAdminComments < ActiveRecord::Migration
  def self.up
    create_table :admin_comments do |t|
      t.references :entity, :polymorphic => true, :null => false
      t.references :admin_user, :polymorphic => true
      t.text :body
      t.timestamps
    end
    add_index :admin_comments, [:entity_type, :entity_id]
    add_index :admin_comments, [:admin_user_type, :admin_user_id]
  end

  def self.down
    drop_table :admin_comments
  end
end
