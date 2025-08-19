# frozen_string_literal: true
require "rails_helper"
require "active_admin/menu"
require "active_admin/menu_item"

module ActiveAdmin
  RSpec.describe MenuItem do
    it "should have a label" do
      item = MenuItem.new(label: "Dashboard")
      expect(item.label).to eq "Dashboard"
    end

    it "should have a url" do
      item = MenuItem.new(url: "/admin")
      expect(item.url).to eq "/admin"
    end

    it "should have a priority of 10 by default" do
      item = MenuItem.new
      expect(item.priority).to eq 10
    end

    it "should default to an empty hash for html_options" do
      item = MenuItem.new
      expect(item.html_options).to be_empty
    end

    it "should accept an options hash for link_to" do
      item = MenuItem.new html_options: { target: "_blank" }
      expect(item.html_options).to include(target: "_blank")
    end

    context "with no items" do
      it "should be empty" do
        item = MenuItem.new
        expect(item.items).to be_empty
      end

      it "should accept new children" do
        item = MenuItem.new label: "Dashboard"
        item.add label: "My Child Dashboard"
        expect(item.items.first).to be_a MenuItem
        expect(item.items.first.label).to eq "My Child Dashboard"
      end
    end

    context "with many children" do
      let(:item) do
        i = MenuItem.new(label: "Dashboard")
        i.add label: "Blog"
        i.add label: "Cars"
        i.add label: "Users", priority: 1
        i.add label: "Settings", priority: 2
        i.add label: "Analytics", priority: 44
        i
      end

      it "should contain 5 submenu items" do
        expect(item.items.count).to eq 5
      end

      it "should give access to the menu item as an array" do
        expect(item["Blog"].label).to eq "Blog"
      end

      it "children should hold a reference to their parent" do
        expect(item["Blog"].parent).to eq item
      end
    end

    describe "#id" do
      it "should be normalized" do
        expect(MenuItem.new(id: "Foo Bar").id).to eq "foo_bar"
      end

      it "should not accept Procs" do
        expect { MenuItem.new(id: proc { "Dynamic" }).id }.to raise_error TypeError
      end
    end
  end
end
