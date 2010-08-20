require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

module ActiveAdmin
  describe ResourceConfig do

    def config(options = {})
      @config ||= ResourceConfig.new(Category, options)
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
      it "should return the default namspace if none given" do
        config.namespace.should == ActiveAdmin.default_namespace
      end
      it "should set the namespace" do
        config(:namespace => :hello_world).namespace.should == :hello_world
      end
      it "should have no namespace" do
        config(:namespace => false).namespace.should == false
      end
    end

    describe "namespace_module_name" do
      it "should be the module name" do
        config(:namespace => :hello_world).namespace_module_name.should == 'HelloWorld'
      end
      it "should be nil" do
        config(:namespace => false).namespace_module_name.should == nil
      end
    end

    describe "controller name" do
      it "should return a namespaced controller name" do
        config.controller_name.should == "Admin::CategoriesController"
      end
      it "should return a non namespaced controller name" do
        config(:namespace => false).controller_name.should == "CategoriesController"
      end
    end

    describe "menu name" do
      it "should return the namespace" do
        config.menu_name.should == :admin
      end
      it "should return :root if no namespace" do
        config(:namespace => false).menu_name.should == :root
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
      before do
        ActiveAdmin.register Category
      end
      let(:config){ ActiveAdmin.resources['Admin::Category'] }
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
