require 'spec_helper'
require 'active_admin/menu'
require 'active_admin/menu_item'

module ActiveAdmin
  describe MenuItem do

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

    context "conditional display" do
      it "should store a Proc internally and evaluate it when requested" do
        item = MenuItem.new
        expect(item.instance_variable_get(:@should_display)).to be_a Proc
        expect(item.display?).to_not be_a Proc
      end

      it "should show the item by default" do
        expect(MenuItem.new.display?).to eq true
      end

      it "should hide the item" do
        expect(MenuItem.new(if: proc{false}).display?).to eq false
      end
    end

    it "should default to an empty hash for html_options" do
      item = MenuItem.new
      expect(item.html_options).to be_empty
    end

    it "should accept an options hash for link_to" do
      item = MenuItem.new html_options: { target: :blank }
      expect(item.html_options).to include(target: :blank)
    end

    context "with no items" do
      it "should be empty" do
        item = MenuItem.new
        expect(item.items).to be_empty
      end

      it "should accept new children" do
        item = MenuItem.new label: "Dashboard"
        item.add            label: "My Child Dashboard"
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
        expect(item['Blog'].label).to eq 'Blog'
      end

      it "should sort items based on priority and name" do
        expect(item.items[0].label).to eq 'Users'
        expect(item.items[1].label).to eq 'Settings'
        expect(item.items[2].label).to eq 'Blog'
        expect(item.items[3].label).to eq 'Cars'
        expect(item.items[4].label).to eq 'Analytics'
      end

      it "children should hold a reference to their parent" do
        expect(item["Blog"].parent).to eq item
      end
    end

    describe "accessing ancestory" do
      let(:item){ MenuItem.new label: "Blog" }

      context "with no parent" do
        it "should return an empty array" do
         expect(item.ancestors).to eq []
        end
      end

      context "with one parent" do
        let(:sub_item) do
          item.add label: "Create New"
          item["Create New"]
        end
        it "should return an array with the parent" do
          expect(sub_item.ancestors).to eq [item]
        end
      end

      context "with many parents" do
        before(:each) do
          c1 = {label: "C1"}
          c2 = {label: "C2"}
          c3 = {label: "C3"}

          item.add(c1).add(c2).add(c3)

          item
        end
        let(:sub_item){ item["C1"]["C2"]["C3"] }
        it "should return an array with the parents in reverse order" do
          expect(sub_item.ancestors).to eq [item["C1"]["C2"], item["C1"], item]
        end
      end
    end # accessing ancestory


    describe "#id" do
      it "should be normalized" do
        expect(MenuItem.new(id: "Foo Bar").id).to eq "foo_bar"
      end

      it "should not accept Procs" do
        expect{ MenuItem.new(id: proc{"Dynamic"}).id }.to raise_error TypeError
      end
    end

  end
end
