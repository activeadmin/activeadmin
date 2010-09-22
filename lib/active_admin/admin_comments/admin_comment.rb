module ActiveAdmin
  class AdminComment < ActiveRecord::Base
    
    belongs_to :entity, :polymorphic => true
    belongs_to :admin_user, :polymorphic => true

    validates_presence_of :entity_id
    validates_presence_of :entity_type
    validates_presence_of :body
    
  end
end
