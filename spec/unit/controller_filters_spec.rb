require 'spec_helper' 

describe ActiveAdmin, "filters" do

  describe "before filters" do
    it "should add a new before filter to ActiveAdmin::ResourceController" do
      ActiveAdmin::ResourceController.should_receive(:before_filter).and_return(true)
      ActiveAdmin.before_filter :my_filter, :only => :show
    end
  end

  describe "after filters" do
    it "should add a new after filter to ActiveAdmin::ResourceController" do
      ActiveAdmin::ResourceController.should_receive(:after_filter).and_return(true)
      ActiveAdmin.after_filter :my_filter, :only => :show
    end
  end

  describe "around filters" do
    it "should add a new around filter to ActiveAdmin::ResourceController" do
      ActiveAdmin::ResourceController.should_receive(:around_filter).and_return(true)
      ActiveAdmin.around_filter :my_filter, :only => :show
    end
  end

end
