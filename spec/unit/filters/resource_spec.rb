require 'spec_helper'

describe ActiveAdmin::Filters::ResourceExtension do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  it "should return the defaults if no filters are set" do
    resource.filters.map{|f| f[:attribute].to_s }.sort.should == %w{
      author body category created_at published_at starred title updated_at
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

  context "filter removal" do
    it "should work" do
      resource.filters.should include :attribute => :author
      resource.remove_filter :author
      resource.filters.should_not include :attribute => :author
    end

    it "should be lazy" do
      resource.should_not_receive :default_filters # this hits the DB
      resource.remove_filter :author
    end

    it "should not prevent the default filters from being added" do
      resource.remove_filter :author
      resource.filters.should_not be_empty
    end
  end

  context "adding a filter" do
    it "should work" do
      resource.add_filter :title
      resource.filters.should == [{:attribute => :title}]
    end

    it "should work with specified options" do
      resource.add_filter :title, :as => :string
      resource.filters.should == [{:attribute => :title, :as => :string}]
    end

    it "should preserve default filters" do
      resource.preserve_default_filters!
      resource.add_filter :count, :as => :string
      resource.filters.map { |f| f[:attribute].to_s }.sort.should == %w{
      author body category count created_at published_at starred title updated_at
    }
    end

    it "should raise an exception when filters are disabled" do
      resource.filters = false
      expect {
        resource.add_filter :title
      }.to raise_error(RuntimeError)
    end
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
