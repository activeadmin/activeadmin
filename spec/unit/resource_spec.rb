require 'spec_helper' 
require File.expand_path('config_shared_examples', File.dirname(__FILE__))

module ActiveAdmin
  describe Resource do

    it_should_behave_like "ActiveAdmin::Config"

    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    it { respond_to :resource_class }

    describe "#resource_table_name" do
      it "should return the resource's table name" do
        config.resource_table_name.should == '"categories"'
      end
      context "when the :as option is given" do
        it "should return the resource's table name" do
          config(:as => "My Category").resource_table_name.should == '"categories"'
        end
      end
    end

    describe "controller name" do
      it "should return a namespaced controller name" do
        config.controller_name.should == "Admin::CategoriesController"
      end
      context "when non namespaced controller" do
        let(:namespace){ ActiveAdmin::Namespace.new(application, :root) }
        it "should return a non namespaced controller name" do
          config.controller_name.should == "CategoriesController"
        end
      end
    end

    describe "#include_in_menu?" do
      let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }
      subject{ resource }

      context "when regular resource" do
        let(:resource){ namespace.register(Post) }
        it { should be_include_in_menu }
      end
      context "when belongs to" do
        let(:resource){ namespace.register(Post){ belongs_to :author } }
        it { should_not be_include_in_menu }
      end
      context "when belongs to optional" do
        let(:resource){ namespace.register(Post){ belongs_to :author, :optional => true} }
        it { should be_include_in_menu }
      end
      context "when menu set to false" do
        let(:resource){ namespace.register(Post){ menu false } }
        it { should_not be_include_in_menu }
      end
    end

    describe "menu item name" do
      it "should be the resource name when not set" do
        config.menu_item_name.should == "Categories"
      end
      it "should be settable" do
        config.menu :label => "My Label"
        config.menu_item_name.should == "My Label"
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
    
    describe "menu item priority" do
      it "should be 10 when not set" do
        config.menu_item_priority.should == 10
      end
      it "should be settable" do
        config.menu :priority => 2
        config.menu_item_priority.should == 2
      end
    end
    
    describe "menu item display if" do
      it "should be a proc always returning true if not set" do
        config.menu_item_display_if.should be_instance_of(Proc)
        config.menu_item_display_if.call.should == true
      end
      it "should be settable" do
        config.menu :if => proc { false }
        config.menu_item_display_if.call.should == false
      end
    end

    describe "route names" do
      it "should return the route prefix" do
        config.route_prefix.should == "admin"
      end
      it "should return the route collection path" do
        config.route_collection_path.should == :admin_categories_path
      end

      context "when in the root namespace" do
        let(:config){ application.register Category, :namespace => false}
        it "should have a nil route_prefix" do
          config.route_prefix.should == nil
        end
      end

      context "when registering a plural resource" do
        class ::News; def self.has_many(*); end end

        let(:config){ application.register News }
        it "should return the plurali route with _index" do
          config.route_collection_path.should == :admin_news_index_path
        end
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
          begin_of_association_chain.should == "scoped"
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
          controller.should_receive(:current_user).and_return(true)
          begin_of_association_chain = controller.send(:begin_of_association_chain)
          begin_of_association_chain.should == true
        end
      end

      context "when not using a block or symbol" do
        before do
          @resource = application.register Category do
            scope_to "Some string"
          end
        end
        it "should raise and exception" do
          lambda {
            @resource.controller.new.send(:begin_of_association_chain)
          }.should raise_error(ArgumentError)
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
            @resource.controller.new.send(:method_for_association_chain).should == :categories
          end
        end
        context "when passing in the method as an option" do
          before do
            @resource = application.register Category do
              scope_to :current_user, :association_method => :blog_categories
            end
          end
          it "should return the method from the option" do
            @resource.controller.new.send(:method_for_association_chain).should == :blog_categories
          end
        end
      end
    end


    describe "sort order" do

      context "when resource class responds to primary_key" do
        it "should sort by primary key desc by default" do
          mock_resource = mock
          mock_resource.should_receive(:primary_key).and_return("pk")
          config = Resource.new(namespace, mock_resource)
          config.sort_order.should == "pk_desc"
        end
      end

      context "when resource class does not respond to primary_key" do
        it "should default to id" do
          mock_resource = mock
          config = Resource.new(namespace, mock_resource)
          config.sort_order.should == "id_desc"
        end
      end

      it "should be set-able" do
        config.sort_order = "task_id_desc"
        config.sort_order.should == "task_id_desc"
      end

    end

    describe "adding a scope" do

      it "should add a scope" do
        config.scope :published
        config.scopes.first.should be_a(ActiveAdmin::Scope)
        config.scopes.first.name.should == "Published"
      end

      it "should retrive a scope by its id" do
        config.scope :published
        config.get_scope_by_id(:published).name.should == "Published"
      end
    end

    describe "#csv_builder" do
      context "when no csv builder set" do
        it "should return a default column builder with id and content columns" do
          config.csv_builder.columns.size.should == Category.content_columns.size + 1
        end
      end

      context "when csv builder set" do
        it "shuld return the csv_builder we set" do
          csv_builder = CSVBuilder.new
          config.csv_builder = csv_builder
          config.csv_builder.should == csv_builder
        end
      end
    end
  end
end
