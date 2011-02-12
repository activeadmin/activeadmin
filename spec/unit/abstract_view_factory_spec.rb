require 'spec_helper'

require 'active_admin/abstract_view_factory'

describe ActiveAdmin::AbstractViewFactory do
  
  let(:view_factory){ ActiveAdmin::AbstractViewFactory.new }
  let(:mock_view){ Class.new }

  describe "registering a new view key" do
    before do
      view_factory.register :my_new_view_class => mock_view
    end

    it "should respond to :my_new_view_class" do
      view_factory.respond_to?(:my_new_view_class)
    end

    it "should respond to :my_new_view_class=" do
      view_factory.respond_to?(:my_new_view_class=)
    end

    it "should generate a getter method" do
      view_factory.my_new_view_class.should == mock_view
    end

    it "should be settable view a setter method" do
      view_factory.my_new_view_class = "Some Obj"
      view_factory.my_new_view_class.should == "Some Obj"
    end
  end

  describe "array syntax access" do
    before do
      view_factory.register :my_new_view_class => mock_view
    end

    it "should be available through array syntax" do
      view_factory[:my_new_view_class].should == mock_view
    end

    it "should be settable through array syntax" do
      view_factory[:my_new_view_class] = "My New View Class"
      view_factory[:my_new_view_class].should == "My New View Class"
    end
  end

  describe "registering default views" do
    before do
      ActiveAdmin::AbstractViewFactory.register :my_default_view_class => mock_view
    end
    it "should generate a getter method" do
      view_factory.my_default_view_class.should == mock_view
    end
    it "should be settable view a setter method and not change default" do
      view_factory.my_default_view_class = "Some Obj"
      view_factory.my_default_view_class.should == "Some Obj"
      view_factory.default_for(:my_default_view_class).should == mock_view
    end
  end

  describe "subclassing the ViewFactory" do
    let(:subclass) do
      ActiveAdmin::AbstractViewFactory.register :my_subclassed_view => "From Parent"
      Class.new(ActiveAdmin::AbstractViewFactory) do
        def my_subclassed_view
          "From Subclass"
        end
      end
    end

    it "should use the subclass implementation" do
      factory = subclass.new
      factory.my_subclassed_view.should == "From Subclass"
    end
  end


end
