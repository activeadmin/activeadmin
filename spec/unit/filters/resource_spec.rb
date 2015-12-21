require 'rails_helper'

describe ActiveAdmin::Filters::ResourceExtension do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  it "should return a Hash" do
    expect(resource.filters).to be_a Hash
  end

  it "should return the defaults if no filters are set" do
    expect(resource.filters.keys).to match_array([
      :author, :body, :category, :created_at, :custom_searcher, :position, :published_at, :starred, :taggings, :title, :updated_at
    ])
  end

  it "should not have defaults when filters are disabled on the resource" do
    resource.filters = false
    expect(resource.filters).to be_empty
  end

  it "should not have defaults when the filters are disabled on the namespace" do
    resource.namespace.filters = false
    expect(resource.filters).to be_empty
  end

  it "should not have defaults when the filters are disabled on the application" do
    resource.namespace.application.filters = false
    expect(resource.filters).to be_empty
  end

  it "should return the defaults without associations if default association filters are disabled on the namespace" do
    resource.namespace.include_default_association_filters = false
    expect(resource.filters.keys).to match_array([
      :body, :created_at, :custom_searcher, :position, :published_at, :starred, :title, :updated_at
    ])
  end

  describe "removing a filter" do
    it "should work" do
      expect(resource.filters.keys).to include :author
      resource.remove_filter :author
      expect(resource.filters.keys).to_not include :author
    end

    it "should work as a string" do
      expect(resource.filters.keys).to include :author
      resource.remove_filter 'author'
      expect(resource.filters.keys).to_not include :author
    end

    it "should be lazy" do
      expect(resource).to_not receive :default_filters # this hits the DB
      resource.remove_filter :author
    end

    it "should not prevent the default filters from being added" do
      resource.remove_filter :author
      expect(resource.filters).to_not be_empty
    end

    it "should raise an exception when filters are disabled" do
      resource.filters = false
      expect{ resource.remove_filter :author }.to raise_error ActiveAdmin::Filters::Disabled
    end
  end

  describe "removing a multiple filters inline" do
    it "should work" do
      expect(resource.filters.keys).to include :author, :body
      resource.remove_filter :author, :body
      expect(resource.filters.keys).to_not include :author, :body
    end
  end

  describe "adding a filter" do
    it "should work" do
      resource.add_filter :title
      expect(resource.filters).to eq title: {}
    end

    it "should work as a string" do
      resource.add_filter 'title'
      expect(resource.filters).to eq title: {}
    end

    it "should work with specified options" do
      resource.add_filter :title, as: :string
      expect(resource.filters).to eq title: {as: :string}
    end

    it "should override an existing filter" do
      resource.add_filter :title, one: :two
      resource.add_filter :title, three: :four

      expect(resource.filters).to eq title: {three: :four}
    end

    it "should preserve default filters" do
      resource.preserve_default_filters!
      resource.add_filter :count, as: :string

      expect(resource.filters.keys).to match_array([
        :author, :body, :category, :count, :created_at, :custom_searcher, :position, :published_at, :starred, :taggings, :title, :updated_at
      ])
    end

    it "should raise an exception when filters are disabled" do
      resource.filters = false
      expect{ resource.add_filter :title }.to raise_error ActiveAdmin::Filters::Disabled
    end
  end

  it "should reset filters" do
    resource.add_filter :title
    expect(resource.filters.size).to eq 1
    resource.reset_filters!
    expect(resource.filters.size).to be > 1
  end

  it "should add a sidebar section for the filters" do
    expect(resource.sidebar_sections.first.name).to eq "filters"
  end

end
