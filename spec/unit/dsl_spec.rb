# frozen_string_literal: true
require "rails_helper"

module MockModuleToInclude
  def self.included(dsl)
  end
end

RSpec.describe ActiveAdmin::DSL do
  let(:application) { ActiveAdmin::Application.new }
  let(:namespace) { ActiveAdmin::Namespace.new application, :admin }
  let(:resource_config) { namespace.register Post }
  let(:dsl) { ActiveAdmin::DSL.new(resource_config) }

  describe "#include" do
    it "should call the included class method on the module that is included" do
      expect(MockModuleToInclude).to receive(:included).with(dsl)
      dsl.run_registration_block do
        include MockModuleToInclude
      end
    end
  end

  describe "#action_item" do
    before do
      @default_items_count = resource_config.action_items.size

      dsl.run_registration_block do
        action_item :awesome, only: :show do
          "Awesome ActionItem"
        end
      end
    end

    it "adds action_item to the action_items of config" do
      expect(resource_config.action_items.size).to eq(@default_items_count + 1)
    end
  end

  describe "#menu" do
    it "should set the menu_item_options on the configuration" do
      expect(resource_config).to receive(:menu_item_options=).with({ parent: "Admin" })
      dsl.run_registration_block do
        menu parent: "Admin"
      end
    end
  end

  describe "#navigation_menu" do
    it "should set the navigation_menu_name on the configuration" do
      expect(resource_config).to receive(:navigation_menu_name=).with(:admin)
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
      dsl.config.sidebar_sections << ActiveAdmin::SidebarSection.new(:email)
    end

    it "add sidebar_section to the sidebar_sections of config" do
      dsl.run_registration_block do
        sidebar :help
      end
      expect(dsl.config.sidebar_sections.map(&:name)).to match_array ["filters", "search_status", "email", "help"]
    end
  end

  describe "#batch_action" do
    describe "title of batch_action" do
      it "default title" do
        dsl.run_registration_block do
          config.batch_actions = true
          batch_action :foo
        end
        expect(resource_config.batch_actions.first.title).to eq "Foo"
      end

      it "default title" do
        dsl.run_registration_block do
          config.batch_actions = true
          batch_action :foo, title: "Custom Foo"
        end
        expect(resource_config.batch_actions.first.title).to eq "Custom Foo"
      end
    end

    it "should add a batch action by symbol" do
      dsl.run_registration_block do
        config.batch_actions = true
        batch_action :foo
      end
      expect(resource_config.batch_actions.map(&:sym)).to eq [:foo, :destroy]
    end

    it "should add a batch action by title" do
      dsl.run_registration_block do
        config.batch_actions = true
        batch_action "foo bar"
      end
      expect(resource_config.batch_actions.map(&:sym)).to eq [:foo_bar, :destroy]
    end
  end
end
