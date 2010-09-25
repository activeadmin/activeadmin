module ActiveAdmin
  class AdminNote < ActiveRecord::Base
    
    belongs_to :resource, :polymorphic => true
    belongs_to :admin_user, :polymorphic => true
    
    validates_presence_of :resource_id
    validates_presence_of :resource_type
    validates_presence_of :body
    
  end
end
