require 'spec_helper_without_rails'
require 'active_admin/menu'
require 'active_admin/menu_item'

module ActiveAdmin
  describe MenuItem do

    it "should have a label" do
      item = MenuItem.new(:label => "Dashboard")
      item.label.should == "Dashboard"
    end

    it "should have a url" do
      item = MenuItem.new(:url => "/admin")
      item.url.should == "/admin"
    end

    it "should have a priority of 10 by default" do
      item = MenuItem.new
      item.priority.should == 10
    end

    it "should have a display if block" do
      block = lambda{ logged_in? }
      item = MenuItem.new(:if => block )
      item.display_if_block.should == block
    end

    it "should have a default display if block always returning true" do
      item = MenuItem.new
      item.display_if_block.should be_instance_of(Proc)
      item.display_if_block.call(self).should == true
    end

    context "with no children" do
      it "should be empty" do
        item = MenuItem.new
        item.children.should == []
      end

      it "should accept new children" do
        item = MenuItem.new
        item.add MenuItem.new(:label => "Dashboard")
        item.children.first.should be_an_instance_of(MenuItem)
        item.children.first.label.should == "Dashboard"
      end
    end

    context "with many children" do
      let(:item) do
        i = MenuItem.new(:label => "Dashboard")
        i.add MenuItem.new(:label => "Blog")
        i.add MenuItem.new(:label => "Cars")
        i.add MenuItem.new(:label => "Users", :priority => 1)
        i.add MenuItem.new(:label => "Settings", :priority => 2)
        i.add MenuItem.new(:label => "Analytics", :priority => 44)
        i
      end

      it "should give access to the menu item as an array" do
        item['Blog'].label.should == 'Blog'
      end

      it "should sort items based on priority and name" do    
        item.children[0].label.should == 'Users'
        item.children[1].label.should == 'Settings'
        item.children[2].label.should == 'Blog'
        item.children[3].label.should == 'Cars'
        item.children[4].label.should == 'Analytics'
      end

      it "children should hold a reference to their parent" do
        item["Blog"].parent.should == item
      end
    end

    describe "accessing ancestory" do
      let(:item){ MenuItem.new :label => "Blog" }

      context "with no parent" do
        it "should return an empty array" do
         item.ancestors.should == [] 
        end
      end

      context "with one parent" do
        let(:sub_item) do 
          item.add MenuItem.new(:label => "Create New")
          item["Create New"]
        end
        it "should return an array with the parent" do
          sub_item.ancestors.should == [item]
        end
      end

      context "with many parents" do
        before(:each) do
          c1 = MenuItem.new(:label => "C1")
          c2 = MenuItem.new(:label => "C2")
          c3 = MenuItem.new(:label => "C3")

          item.add(c1)
          c1.add c2
          c2.add c3

          item
        end
        let(:sub_item){ item["C1"]["C2"]["C3"] }
        it "should return an array with the parents in reverse order" do
          sub_item.ancestors.should == [item["C1"]["C2"], item["C1"], item]
        end
      end
    end # accessing ancestory


    describe ".generate_item_id" do

      it "downcases the id" do
        MenuItem.generate_item_id("Identifier").should == "identifier"
      end

      it "should set underscore any spaces" do
        MenuItem.generate_item_id("An Id").should == "an_id"
      end

    end

  end
end
