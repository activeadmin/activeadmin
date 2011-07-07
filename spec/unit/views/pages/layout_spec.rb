require 'spec_helper'

describe ActiveAdmin::Views::Pages::Layout do

  describe "the page title" do

    it "should be the @page_title if assigned in the controller" do
      assigns = {:page_title => "My Page Title"}
      layout = ActiveAdmin::Views::Pages::Layout.new(assigns, nil)
      layout.title.should == "My Page Title"
    end

    it "should be the default translation" do
      assigns = {}
      helpers = mock(:params => {:action => 'edit'})
      layout = ActiveAdmin::Views::Pages::Layout.new(assigns, helpers)
      layout.title.should == "Edit"
    end

  end

end
