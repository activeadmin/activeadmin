require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe ActiveAdmin::Sidebar do

  include RSpec::Rails::ControllerExampleGroup
  render_views  
  metadata[:behaviour][:describes] = Admin::CategoriesController

  before :all do
    load_defaults!
    reload_routes!
  end

  # Store the config and set it back after each spec so that we
  # dont mess with other specs
  before do
    @config_before = Admin::CategoriesController.sidebar_sections.dup
    Admin::CategoriesController.clear_sidebar_sections!
  end

  after(:each) do
    Admin::CategoriesController.sidebar_sections = @config_before
  end

  # Helper method to define a sidebar
  def sidebar(name, options = {}, &block)
    ActiveAdmin.register Category do
      sidebar(name, options, &block)
    end
  end

  context "when setting with a block" do
    before do
      sidebar :my_filters do
        link_to "My Filters", '#'
      end
      get :index
    end
    it "should add a new sidebar to @sidebar_sections" do
      Admin::CategoriesController.sidebar_sections.size.should == 1
    end
    it "should render content in the context of the view" do
      response.should have_tag("a", "My Filters")
    end
    it "should put a title for the section" do
      response.should have_tag("h3", "My Filters")
    end
  end

  context "when only adding to the index action" do
    before do
      sidebar(:filters, :only => :index){ }
    end
    it "should be available on index" do
      Admin::CategoriesController.sidebar_sections_for(:index).size.should == 1
    end
    it "should not be available on edit" do
      Admin::CategoriesController.sidebar_sections_for(:edit).size.should == 0
    end
  end

  context "when adding to all except index action" do
    before do
      sidebar(:filters, :except => :index){ }
    end
    it "should not be availbale on index" do
      Admin::CategoriesController.sidebar_sections_for(:index).size.should == 0
    end
    it "should be available on edit" do
      Admin::CategoriesController.sidebar_sections_for(:edit).size.should == 1
    end
  end

  context "when setting with a class"

  describe "rendering partials" do
    let(:sections){ [section] }
    let(:renderer){ ActiveAdmin::Views::SidebarRenderer.new(action_view) }
    let(:render!){ renderer.to_html(sections) }

    context "when a partial name is set" do
      let(:section){ ActiveAdmin::Sidebar::Section.new(:filters, :partial => 'custom_partial') }

      it "should render the partial" do
        renderer.should_receive(:render).with('custom_partial').and_return("woot")
        render!.should include("woot")
      end
    end

    context "when no partial name is set" do
      let(:section){ ActiveAdmin::Sidebar::Section.new(:filters) }

      it "should render the partial based on the name of the sidebar section" do
        renderer.should_receive(:render).with('filters_sidebar').and_return("woot")
        render!.should include("woot")
      end
    end
  end

end
