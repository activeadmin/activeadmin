require 'rails_helper'

RSpec.describe ActiveAdmin::Filters::ResourceExtension do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  it "should return a Hash" do
    expect(resource.filters).to be_a Hash
  end

  it "should return the defaults if no filters are set" do
    expect(resource.filters.keys).to match_array([
      :author, :body, :category, :created_at, :custom_created_at_searcher, :custom_title_searcher, :custom_searcher_numeric, :position, :published_date, :starred, :taggings, :title, :updated_at, :foo_id
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
      :body, :created_at, :custom_created_at_searcher, :custom_title_searcher, :custom_searcher_numeric, :position, :published_date, :starred, :title, :updated_at, :foo_id
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
        :author, :body, :category, :count, :created_at, :custom_created_at_searcher, :custom_title_searcher, :custom_searcher_numeric, :position, :published_date, :starred, :taggings, :title, :updated_at, :foo_id
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

  describe "cacheable filters" do
    let(:view) { action_view }

    context "with caching enabled" do
      it "should cache the collection" do
        action_controller_double = double(perform_caching: true)
        configuration_double     = double(action_controller: action_controller_double)
        cache_double             = double(fetch: "")

        allow(Rails).to receive(:cache).and_return(cache_double)
        allow(Rails).to receive(:configuration).and_return(configuration_double)
        allow(view).to  receive(:collection_path).and_return("admin/posts")

        resource.add_filter :author, as: :select, cache: true

        # This is a hacky kind of way to force the select filters being created
        view.active_admin_filters_form_for(Post.search, resource.filters)

        expect(action_controller_double).to have_received :perform_caching
        expect(cache_double).to have_received :fetch
      end

      it "should use a specified cache_key as part of full cache path" do
        action_controller_double = double(perform_caching: true)
        configuration_double     = double(action_controller: action_controller_double)
        cache_double             = double(fetch: "")

        allow(Rails).to receive(:cache).and_return(cache_double)
        allow(Rails).to receive(:configuration).and_return(configuration_double)
        allow(view).to  receive(:collection_path).and_return("admin/posts")

        resource.add_filter :author, as: :select, cache: true, cache_key: -> { "foo-123" }

        view.active_admin_filters_form_for(Post.search, resource.filters)

        expect(action_controller_double).to have_received :perform_caching
        expect(cache_double).to have_received(:fetch).with("filter/Post/author/foo-123")
      end
    end

    context "with caching disabled" do
      it "should not cache the collection" do
        action_controller_double = double(perform_caching: false)
        configuration_double     = double(action_controller: action_controller_double)
        cache_double             = double(fetch: "")

        allow(Rails).to receive(:cache).and_return(cache_double)
        allow(Rails).to receive(:configuration).and_return(configuration_double)
        allow(view).to  receive(:collection_path).and_return("admin/posts")

        resource.add_filter :author, as: :select, cache: true

        view.active_admin_filters_form_for(Post.search, resource.filters)

        expect(action_controller_double).to have_received :perform_caching
        expect(cache_double).not_to have_received :fetch
      end
    end
  end

end
