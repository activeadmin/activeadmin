require 'spec_helper'

describe ActiveAdmin::Filters::ResourceExtension do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  it "should return the defaults if no filters are set" do
    resource.filters.map{|f| f[:attribute].to_s }.sort.should == %w{
      author body category created_at published_at title updated_at
    }
  end

  it "should not have defaults when filters are disabled on the resource" do
    resource.filters = false
    resource.filters.should be_empty
  end

  it "should not have defaults when the filters are disabled on the namespace" do
    resource.namespace.filters = false
    resource.filters.should be_empty
  end

  it "should not have defaults when the filters are disabled on the application" do
    resource.namespace.application.filters = false
    resource.filters.should be_empty
  end

  it "should add a filter" do
    resource.add_filter :title
    resource.filters.should == [{:attribute => :title}]
  end

  it "should add a filter with options" do
    resource.add_filter :title, :as => :string
    resource.filters.should == [{:attribute => :title, :as => :string}]
  end

  it "should raise an exception if trying to add a filter when they are disabled" do
    resource.filters = false
    expect {
      resource.add_filter :title
    }.should raise_error(RuntimeError)
  end

  it "should reset filters" do
    resource.add_filter :title
    resource.filters.size.should == 1
    resource.reset_filters!
    resource.filters.size.should > 1
  end

  it "should add a sidebar section for the filters" do
    resource.sidebar_sections.first.name.should == :filters
  end


end
