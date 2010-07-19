require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

module ActiveAdmin
  describe ResourceConfig do

    def config(options = {})
      ResourceConfig.new(Category, options)
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

  end
end
