require 'spec_helper'

describe ActiveAdmin::Resource::Sidebars do

  let(:resource) do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register(Post)
  end

  let(:sidebar) { ActiveAdmin::SidebarSection.new(:help) }

  describe "adding a new sidebar section" do

    before do
      resource.clear_sidebar_sections!
      resource.sidebar_sections << sidebar
    end

    it "should add a sidebar section" do
      expect(resource).to have(1).sidebar_sections
    end

  end

  describe "retrieving sections for a controller action" do

    let(:only_index){ ActiveAdmin::SidebarSection.new(:help, only: :index) }
    let(:only_show){ ActiveAdmin::SidebarSection.new(:help, only: :show) }

    before do
      resource.clear_sidebar_sections!
      resource.sidebar_sections << only_index
      resource.sidebar_sections << only_show
    end

    it "should only return the relevant action items" do
      expect(resource).to have(2).sidebar_sections
      expect(resource.sidebar_sections_for("index")).to eq [only_index]
    end

  end

end
