require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveAdmin::AdminNotes::NotesController do
  include RSpec::Rails::ControllerExampleGroup
  metadata[:behaviour][:describes] = ActiveAdmin::AdminNotes::NotesController

  describe "relating admin notes to admin users" do

    def do_create
      @post = Post.create :title => "Hello World"
      post :create, :admin_note => {
          :body => "This is an amazing admin note", 
          :resource_type => 'Post', 
          :resource_id => @post.id }
    end

    context "when admin user not set" do
      it "should not add an Admin User to a new Admin Note" do
        ActiveAdmin.current_user_method = false
        controller.should_not_receive(:assign_admin_note_to_current_admin_user)
        do_create
      end
    end

    # TODO: Update to work with new authentication scheme
    context "when admin user set" do
      it "should add the current Admin User to a new Admin Note" do
        pending
        #ActiveAdmin.current_user_method = :current_admin_user
        #controller.should_receive(:assign_admin_note_to_current_admin_user)
        #do_create
      end
    end
  end

end
