require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

module ActiveAdmin
  describe Resource do

    let(:namespace){ Namespace.new(:admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    describe "underscored resource name" do
      context "when class" do
        it "should be the underscored singular resource name" do
          config.underscored_resource_name.should == "category"
        end
      end
      context "when a class in a module" do
        it "should underscore the module and the class" do
          module ::Mock; class Resource; end; end
          Resource.new(namespace, Mock::Resource).underscored_resource_name.should == "mock_resource"
        end
      end
      context "when you pass the 'as' option" do
        it "should underscore the passed through string and singulralize" do
          config(:as => "Blog Categories").underscored_resource_name.should == "blog_category"
        end
      end
    end

    describe "camelized resource name" do
      it "should return a camelized version of the underscored resource name" do
        config(:as => "Blog Categories").camelized_resource_name.should == "BlogCategory"
      end
    end

    describe "resource name" do
      it "should return a pretty name" do
        config.resource_name.should == "Category"
      end
      it "should return the plural version" do
        config.plural_resource_name.should == "Categories"
      end
      context "when the :as option is give" do
        it "should return the custom name" do
          config(:as => "My Category").resource_name.should == "My Category"
        end
      end
    end

    describe "namespace" do
      it "should return the namespace" do
        config.namespace.should == namespace
      end
    end

    describe "controller name" do
      it "should return a namespaced controller name" do
        config.controller_name.should == "Admin::CategoriesController"
      end
      context "when non namespaced controller" do
        let(:namespace){ ActiveAdmin::Namespace.new(:root) }
        it "should return a non namespaced controller name" do
          config.controller_name.should == "CategoriesController"
        end
      end
    end

    describe "parent menu item name" do
      it "should be nil when not set" do
        config.parent_menu_item_name.should == nil
      end
      it "should return the name if set" do
        config.tap do |c|
          c.menu :parent => "Blog"
        end.parent_menu_item_name.should == "Blog"
      end
    end

    describe "route names" do
      let(:config){ ActiveAdmin.register Category }
      it "should return the route prefix" do
        config.route_prefix.should == "admin"
      end
      it "should return the route collection path" do
        config.route_collection_path.should == :admin_categories_path
      end
    end

    describe "page configs" do
      context "when initialized" do
        it "should be empty" do
          config.page_configs.should == {}
        end
      end
      it "should be set-able" do
        config.page_configs[:index] = "hello world"
        config.page_configs[:index].should == "hello world"
      end
    end

    describe "scoping" do
      let(:controller){ Admin::CategoriesController.new }
      let(:begin_of_association_chain){ controller.send(:begin_of_association_chain) }

      context "when using a block" do
        before do
          ActiveAdmin.register Category do
            scope_to do
              "scoped"
            end
          end
        end
        it "should call the proc for the begin of association chain" do
          begin_of_association_chain.should == "scoped"
        end
      end

      context "when using a symbol" do
        before do
          ActiveAdmin.register Category do
            scope_to :current_user
          end
        end
        it "should call the method for the begin of association chain" do
          controller.should_receive(:current_user).and_return(true)
          begin_of_association_chain.should == true
        end
      end

      context "when not using a block or symbol" do
        before do
          ActiveAdmin.register Category do
            scope_to "Some string"
          end
        end
        it "should raise and exception" do
          lambda {
            begin_of_association_chain
          }.should raise_error(ArgumentError)
        end
      end

      describe "getting the method for the association chain" do
        context "when a simple registration" do
          before do
            ActiveAdmin.register Category do
              scope_to :current_user
            end
          end
          it "should return the pluralized collection name" do
            controller.send(:method_for_association_chain).should == :categories
          end
        end
        context "when passing in the method as an option" do
          before do
            ActiveAdmin.register Category do
              scope_to :current_user, :association_method => :blog_categories
            end
          end
          it "should return the method from the option" do
            controller.send(:method_for_association_chain).should == :blog_categories
          end
        end
      end
    end

    describe "dashboard controller name" do
      context "when namespaced" do
        subject{ config.dashboard_controller_name }
        it { should == "Admin::DashboardController" }
      end
      context "when not namespaced" do
        let(:namespace){ ActiveAdmin::Namespace.new(:root) }
        subject{ config.dashboard_controller_name }
        it { should == "DashboardController" }
      end
    end

    describe "sort order" do
      subject { resource_config.sort_order }

      context "by default" do
        let(:resource_config) { config }

        it { should == ActiveAdmin.default_sort_order }
      end

      context "when default_sort_order is set" do
        let(:sort_order)      { "name_desc"                      }
        let(:resource_config) { config :sort_order => sort_order }

        it { should == sort_order }
      end
    end
  end
end
