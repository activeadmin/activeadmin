require 'spec_helper'


module MockModuleToInclude
  def self.included(dsl)
  end
end

describe ActiveAdmin::DSL do

  let(:config){ double }
  let(:application) { ActiveAdmin::Application.new }
  let(:namespace) { ActiveAdmin::Namespace.new application, :admin }
  let(:resource_config) { ActiveAdmin::Resource.new namespace, Post }
  let(:dsl){ ActiveAdmin::DSL.new(config) }

  describe "#include" do

    it "should call the included class method on the module that is included" do
      expect(MockModuleToInclude).to receive(:included).with(dsl)
      dsl.run_registration_block do
        include MockModuleToInclude
      end
    end

  end

  describe "#menu" do

    it "should set the menu_item_options on the configuration" do
      expect(config).to receive(:menu_item_options=).with({parent: "Admin"})
      dsl.run_registration_block do
        menu parent: "Admin"
      end
    end

  end

  describe "#navigation_menu" do

    it "should set the navigation_menu_name on the configuration" do
      expect(config).to receive(:navigation_menu_name=).with(:admin)
      dsl.run_registration_block do
        navigation_menu :admin
      end
    end

    it "should accept a block" do

      dsl = ActiveAdmin::DSL.new(resource_config)
      dsl.run_registration_block do
        navigation_menu { :dynamic_menu }
      end

      expect(resource_config.navigation_menu_name).to eq :dynamic_menu

    end

  end

  describe "#sidebar" do

    before do
      allow(config).to receive(:sidebar_sections).and_return([])
      dsl.config.sidebar_sections << ActiveAdmin::SidebarSection.new(:email)
    end

    it "add sidebar_section to the sidebar_sections on the configuration" do
      dsl.run_registration_block do
        sidebar :help
      end
      expect(config.sidebar_sections.map(&:name)).to match_array([:email, :help])
    end

  end

end
