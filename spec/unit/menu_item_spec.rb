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

    it "should default to an empty hash for html_options" do
      item = MenuItem.new
      item.html_options.should be_empty
    end

    it "should accept an options hash for link_to" do
      item = MenuItem.new :html_options => { :target => :blank }
      item.html_options.should include(:target => :blank)
    end

    context "with no items" do
      it "should be empty" do
        item = MenuItem.new
        item.items.should == []
      end

      it "should accept new children" do
        item = MenuItem.new
        item.add :label => "Dashboard"
        item.items.first.should be_an_instance_of(MenuItem)
        item.items.first.label.should == "Dashboard"
      end
    end

    context "with many children" do
      let(:item) do
        i = MenuItem.new(:label => "Dashboard")
        i.add :label => "Blog"
        i.add :label => "Cars"
        i.add :label => "Users", :priority => 1
        i.add :label => "Settings", :priority => 2
        i.add :label => "Analytics", :priority => 44
        i
      end

      it "should give access to the menu item as an array" do
        item['Blog'].label.should == 'Blog'
      end

      it "should sort items based on priority and name" do    
        item.items[0].label.should == 'Users'
        item.items[1].label.should == 'Settings'
        item.items[2].label.should == 'Blog'
        item.items[3].label.should == 'Cars'
        item.items[4].label.should == 'Analytics'
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
          item.add :label => "Create New"
          item["Create New"]
        end
        it "should return an array with the parent" do
          sub_item.ancestors.should == [item]
        end
      end

      context "with many parents" do
        before(:each) do
          c1 = {:label => "C1"}
          c2 = {:label => "C2"}
          c3 = {:label => "C3"}

          item.add(c1).add(c2).add(c3)

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
        MenuItem.new(:id => "Identifier").id.should == "identifier"
      end

      it "should set underscore any spaces" do
        MenuItem.new(:id => "An Id").id.should == "an_id"
      end

      it "should return a proc if label was a proc" do
        MenuItem.new(:label => proc{ "Dynamic" }).id.should be_an_instance_of(Proc)
      end

    end

  end
end
