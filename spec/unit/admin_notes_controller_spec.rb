require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveAdmin::AdminNotesController do
  include RSpec::Rails::ControllerExampleGroup
  metadata[:behaviour][:describes] = ActiveAdmin::AdminNotesController
  
  describe "relating admin notes to admin users" do    
   
    def do_create
      post :create, :admin_note => {:body => "This is an amazing admin note", :resource_type => Post, :resource_id => 1}
    end
    
    context "when admin user not set" do
      it "should not add an Admin User to a new Admin Note" do
        controller.should_not_receive(:assign_admin_note_to_current_admin_user)
        do_create
      end
    end
    
    context "when admin user set" do
      it "should add the current Admin User to a new Admin Note" do
        ActiveAdmin.current_admin_user_method = :current_admin_user
        controller.should_receive(:assign_admin_note_to_current_admin_user)
        do_create
      end
    end
  end
  
end
