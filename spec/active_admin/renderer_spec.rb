require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdmin

describe ActiveAdmin::Renderer do

  include ActiveAdminIntegrationSpecHelper

  context "when initiailizing from a view" do
    it "should have a view" do
      view = action_view
      renderer = Renderer.new(view)
      renderer.view.should == view
    end

    it "should assign all local variables from the view" do
      Renderer.new(action_view(:foo => "bar")).send(:instance_variable_get, "@foo").should == "bar"
    end
    
    it "should assing an instance variable to the view" do
      view = action_view
      renderer = Renderer.new(view)
      renderer.send :set_ivar_on_view, "@my_ivar", 'Hello World'
      view.instance_variable_get("@my_ivar").should == 'Hello World'
    end
  end

  context "when initializing from another renderer" do
    it "should have the view" do
      view = action_view
      renderer = Renderer.new(Renderer.new(view))
      renderer.view.should == view
    end

    it "should assign local variables from the renderer" do
      view = action_view(:foo => 'bar')
      renderer = Renderer.new(Renderer.new(view))
      renderer.send(:instance_variable_get, "@foo").should == 'bar'
    end

    it "should assing an instance variable to the view" do
      view = action_view
      renderer = Renderer.new(Renderer.new(view))
      renderer.send :set_ivar_on_view, "@my_ivar", 'Hello World'
      view.instance_variable_get("@my_ivar").should == 'Hello World'
    end    
  end
end
