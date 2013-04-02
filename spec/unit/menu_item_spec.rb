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

    context "conditional display" do
      it "should store a Proc internally and evaluate it when requested" do
        item = MenuItem.new
        item.instance_variable_get(:@should_display).should be_a Proc
        item.display?.should_not be_a Proc
      end

      it "should show the item by default" do
        MenuItem.new.display?.should == true
      end

      it "should hide the item" do
        MenuItem.new(:if => proc{false}).display?.should == false
      end
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
        item.items.should be_empty
      end

      it "should accept new children" do
        item = MenuItem.new :label => "Dashboard"
        item.add            :label => "My Child Dashboard"
        item.items.first.should be_a MenuItem
        item.items.first.label.should == "My Child Dashboard"
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

      it "should contain 5 submenu items" do
        item.items.count.should == 5
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


    describe "#id" do
      it "should be normalized" do
        MenuItem.new(:id => "Foo Bar").id.should == "foo_bar"
      end

      it "should not accept Procs" do
        expect{ MenuItem.new(:id => proc{"Dynamic"}).id }.to raise_error TypeError
      end
    end

  end
end
