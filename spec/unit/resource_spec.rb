# frozen_string_literal: true
require "rails_helper"
require File.expand_path("config_shared_examples", __dir__)

module ActiveAdmin
  RSpec.describe Resource do
    it_should_behave_like "ActiveAdmin::Resource"

    around do |example|
      with_resources_during(example) { namespace.register Category }
    end

    let(:application) { ActiveAdmin::Application.new }
    let(:namespace) { Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    it { respond_to :resource_class }

    describe "#resource_table_name" do
      it "should return the resource's table name" do
        expect(config.resource_table_name).to eq '"categories"'
      end

      context "when the :as option is given" do
        it "should return the resource's table name" do
          expect(config(as: "My Category").resource_table_name).to eq '"categories"'
        end
      end
    end

    describe "#resource_column_names" do
      it "should return the resource's column names" do
        expect(config.resource_column_names).to eq Category.column_names
      end
    end

    describe "#decorator_class" do
      it "returns nil by default" do
        expect(config.decorator_class).to eq nil
      end

      context "when a decorator is defined" do
        around do |example|
          with_resources_during(example) { resource }
        end

        let(:resource) { namespace.register(Post) { decorate_with PostDecorator } }
        specify "#decorator_class_name should return PostDecorator" do
          expect(resource.decorator_class_name).to eq "::PostDecorator"
        end

        it "returns the decorator class" do
          expect(resource.decorator_class).to eq PostDecorator
        end
      end
    end

    describe "controller name" do
      it "should return a namespaced controller name" do
        expect(config.controller_name).to eq "Admin::CategoriesController"
      end

      context "when non namespaced controller" do
        let(:namespace) { ActiveAdmin::Namespace.new(application, :root) }
        it "should return a non namespaced controller name" do
          expect(config.controller_name).to eq "CategoriesController"
        end
      end
    end

    describe "#include_in_menu?" do
      subject { resource }

      around do |example|
        with_resources_during(example) { resource }
      end

      context "when regular resource" do
        let(:resource) { namespace.register(Post) }
        it { is_expected.to be_include_in_menu }
      end

      context "when menu set to false" do
        let(:resource) { namespace.register(Post) { menu false } }
        it { is_expected.not_to be_include_in_menu }
      end
    end

    describe "#belongs_to" do
      it "should build a belongs to configuration" do
        expect(config.belongs_to_config).to eq nil
        config.belongs_to :posts
        expect(config.belongs_to_config).to_not eq nil
      end

      it "should not set the target menu to the belongs to target" do
        expect(config.navigation_menu_name).to eq ActiveAdmin::DEFAULT_MENU
        config.belongs_to :posts
        expect(config.navigation_menu_name).to eq ActiveAdmin::DEFAULT_MENU
      end
    end

    describe "scoping" do
      context "when using a block" do
        before do
          @resource = application.register Category do
            scope_to do
              "scoped"
            end
          end
        end
        it "should call the proc for the begin of association chain" do
          begin_of_association_chain = @resource.controller.new.send(:begin_of_association_chain)
          expect(begin_of_association_chain).to eq "scoped"
        end
      end

      context "when using a symbol" do
        before do
          @resource = application.register Category do
            scope_to :current_user
          end
        end
        it "should call the method for the begin of association chain" do
          controller = @resource.controller.new
          expect(controller).to receive(:current_user).and_return(true)
          begin_of_association_chain = controller.send(:begin_of_association_chain)
          expect(begin_of_association_chain).to eq true
        end
      end

      describe "getting the method for the association chain" do
        context "when a simple registration" do
          before do
            @resource = application.register Category do
              scope_to :current_user
            end
          end
          it "should return the pluralized collection name" do
            expect(@resource.controller.new.send(:method_for_association_chain)).to eq :categories
          end
        end

        context "when passing in the method as an option" do
          before do
            @resource = application.register Category do
              scope_to :current_user, association_method: :blog_categories
            end
          end
          it "should return the method from the option" do
            expect(@resource.controller.new.send(:method_for_association_chain)).to eq :blog_categories
          end
        end
      end
    end

    describe "sort order" do
      class MockResource
      end

      context "when resource class responds to primary_key" do
        it "should sort by primary key desc by default" do
          expect(MockResource).to receive(:primary_key).and_return("pk")
          config = Resource.new(namespace, MockResource)
          expect(config.sort_order).to eq "pk_desc"
        end
      end

      context "when resource class does not respond to primary_key" do
        it "should default to id" do
          config = Resource.new(namespace, MockResource)
          expect(config.sort_order).to eq "id_desc"
        end
      end

      it "should be set-able" do
        config.sort_order = "task_id_desc"
        expect(config.sort_order).to eq "task_id_desc"
      end
    end

    describe "adding a scope" do
      it "should add a scope" do
        config.scope :published
        expect(config.scopes.first).to be_a(ActiveAdmin::Scope)
        expect(config.scopes.first.name).to eq "Published"
        expect(config.scopes.first.show_count).to eq true
      end

      context "when show_count disabled" do
        it "should add a scope show_count = false" do
          namespace.scopes_show_count = false
          config.scope :published
          expect(config.scopes.first.show_count).to eq false
        end
      end

      it "should retrive a scope by its id" do
        config.scope :published
        expect(config.get_scope_by_id(:published).name).to eq "Published"
      end

      it "should retrieve the default scope by proc" do
        config.scope :published, default: proc { true }
        config.scope :all
        expect(config.default_scope.name).to eq "Published"
      end
    end

    describe "#csv_builder" do
      context "when no csv builder set" do
        it "should return a default column builder with id and content columns" do
          expect(config.csv_builder.exec_columns.size).to eq @config.content_columns.size + 1
        end
      end

      context "when csv builder set" do
        it "shuld return the csv_builder we set" do
          csv_builder = CSVBuilder.new
          config.csv_builder = csv_builder
          expect(config.csv_builder).to eq csv_builder
        end
      end
    end

    describe "#breadcrumb" do
      subject { config.breadcrumb }

      context "when no breadcrumb is set" do
        it { is_expected.to eq(namespace.breadcrumb) }
      end

      context "when breadcrumb is set" do
        context "when set to true" do
          before { config.breadcrumb = true }
          it { is_expected.to eq true }
        end

        context "when set to false" do
          before { config.breadcrumb = false }
          it { is_expected.to eq false }
        end
      end
    end

    describe "#find_resource" do
      let(:post) { double }

      around do |example|
        with_resources_during(example) { resource }
      end

      context "without a decorator" do
        let(:resource) { namespace.register(Post) }

        it "can find the resource" do
          allow(Post).to receive(:find_by).with("id" => "12345") { post }
          expect(resource.find_resource("12345")).to eq post
        end
      end

      context "with a decorator" do
        let(:resource) { namespace.register(Post) { decorate_with PostDecorator } }

        it "decorates the resource" do
          allow(Post).to receive(:find_by).with("id" => "12345") { post }
          expect(resource.find_resource("12345")).to eq PostDecorator.new(post)
        end

        it "does not decorate a not found resource" do
          allow(Post).to receive(:find_by).with("id" => "54321") { nil }
          expect(resource.find_resource("54321")).to equal nil
        end
      end

      context "when using a nonstandard primary key" do
        let(:resource) { namespace.register(Post) }

        before do
          allow(Post).to receive(:primary_key).and_return "something_else"
          allow(Post).to receive(:find_by).with("something_else" => "55555") { post }
        end

        it "can find the post by the custom primary key" do
          expect(resource.find_resource("55555")).to eq post
        end
      end

      context "when using controller finder" do
        let(:resource) do
          namespace.register(Post) do
            controller do
              defaults finder: :find_by_title!
            end
          end
        end

        after do
          Admin.send(:remove_const, :"PostsController")
        end

        it "can find the post by controller finder" do
          allow(Post).to receive(:find_by_title!).with("title-name").and_return(post)

          expect(resource.find_resource("title-name")).to eq post
        end
      end
    end

    describe "delegation" do
      let(:controller) do
        Class.new do
          def method_missing(name, *args, &block)
            "called #{name}"
          end
        end.new
      end
      let(:resource) { ActiveAdmin::ResourceDSL.new(double) }

      before do
        expect(resource).to receive(:controller).and_return(controller)
      end

      context "actions" do
        [
          :before_action, :skip_before_action,
          :after_action, :skip_after_action,
          :around_action, :skip_action
        ].each do |method|
          it "delegates #{method}" do
            expect(resource.send(method)).to eq "called #{method}"
          end
        end
      end
    end
  end
end
