# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Namespace, "registering a page" do
  let(:application) { ActiveAdmin::Application.new }
  let(:namespace) { ActiveAdmin::Namespace.new(application, :admin) }
  let(:menu) { namespace.fetch_menu(:default) }

  context "with no configuration" do
    before do
      namespace.register_page "Status"
    end

    it "should store the namespaced registered configuration" do
      expect(namespace.resources.keys).to include("Status")
    end

    it "should create a new controller in the default namespace" do
      expect(defined?(Admin::StatusController)).to eq "constant"
    end

    it "should create a menu item" do
      expect(menu["Status"]).to be_an_instance_of(ActiveAdmin::MenuItem)
    end
  end

  context "with a block configuration" do
    it "should be evaluated in the dsl" do
      expect do |block|
        namespace.register_page "Status", &block
      end.to yield_control
    end
  end

  describe "adding to the menu" do
    describe "adding as a top level item" do
      before do
        namespace.register_page "Status"
      end

      it "should add a new menu item" do
        expect(menu["Status"]).to_not eq nil
      end
    end

    describe "adding as a child" do
      before do
        namespace.register_page "Status" do
          menu parent: "Extra"
        end
      end

      it "should generate the parent menu item" do
        expect(menu["Extra"]).to_not eq nil
      end

      it "should generate its own child item" do
        expect(menu["Extra"]["Status"]).to_not eq nil
      end
    end

    describe "disabling the menu" do
      before do
        namespace.register_page "Status" do
          menu false
        end
      end

      it "should not create a menu item" do
        expect(menu["Status"]).to eq nil
      end
    end # describe "disabling the menu"
  end # describe "adding to the menu"

  describe "adding as a belongs to" do
    context "when not optional" do
      before do
        namespace.register_page "Reports" do
          belongs_to :author
        end
      end

      it "should be excluded from the menu" do
        expect(menu["Reports"]).to be_nil
      end
    end

    context "when optional" do
      before do
        namespace.register_page "Reports" do
          belongs_to :author, optional: true
        end
      end

      it "should be in the menu" do
        expect(menu["Reports"]).to_not be_nil
      end
    end
  end # describe "adding as a belongs to"
end
