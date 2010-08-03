require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveAdmin::AdminController do
  
  [:index, :show].each do |page|
    describe "#{page} config" do
      before do
        Admin::PostsController.send(:"reset_#{page}_config!")
      end

      it "should be set" do
        Admin::PostsController.send(page)
        Admin::PostsController.send(:"#{page}_config").should be_an_instance_of(ActiveAdmin::PageConfig)
      end

      it "should store the block" do
        block = Proc.new {}
        Admin::PostsController.send(:"#{page}", &block)
        Admin::PostsController.send(:"#{page}_config").block.should == block
      end

      it "should be reset" do
        Admin::PostsController.send(:"reset_#{page}_config!")
        Admin::PostsController.send(:"#{page}_config").should == nil
      end
    end
  end

end
