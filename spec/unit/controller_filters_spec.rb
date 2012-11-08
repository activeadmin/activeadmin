require 'spec_helper' 

describe ActiveAdmin, "filters" do
  let(:application){ ActiveAdmin::Application.new }

  describe "before filters" do
    it "should add a new before filter to ActiveAdmin::BaseController" do
      ActiveAdmin::BaseController.should_receive(:before_filter).and_return(true)
      application.before_filter :my_filter, :only => :show
    end
  end
  
  describe "skip before filters" do
    it "should add a new skip before filter to ActiveAdmin::BaseController" do
      ActiveAdmin::BaseController.should_receive(:skip_before_filter).and_return(true)
      application.skip_before_filter :my_filter, :only => :show
    end
  end

  describe "after filters" do
    it "should add a new after filter to ActiveAdmin::BaseController" do
      ActiveAdmin::BaseController.should_receive(:after_filter).and_return(true)
      application.after_filter :my_filter, :only => :show
    end
  end

  describe "around filters" do
    it "should add a new around filter to ActiveAdmin::BaseController" do
      ActiveAdmin::BaseController.should_receive(:around_filter).and_return(true)
      application.around_filter :my_filter, :only => :show
    end
  end

end
