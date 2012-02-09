require 'spec_helper_without_rails'
require 'active_admin/menu_item'

module ActiveAdmin
  describe MenuItem do

    it "should have a name" do
      item = MenuItem.new("Dashboard", "/admin")
      item.name.should == "Dashboard"
    end

    it "should have a url" do
      item = MenuItem.new("Dashboard", "/admin")
      item.url.should == "/admin"
    end

    it "should have a priority of 10 by default" do
      item = MenuItem.new("Dashboard", "/admin")
      item.priority.should == 10
    end

    it "should accept an optional options hash" do
      item = MenuItem.new("Dashboard", "/admin", 10, :if => lambda{ logged_in? } )
    end

    it "should have a display if block" do
      block = lambda{ logged_in? }
      item = MenuItem.new("Dashboard", "/admin", 10, :if => block )
      item.display_if_block.should == block
    end

    it "should have a default display if block always returning true" do
      item = MenuItem.new("Dashboard", "/admin")
      item.display_if_block.should be_instance_of(Proc)
      item.display_if_block.call(self).should == true
    end

    context "with no children" do
      it "should be empty" do
        item = MenuItem.new("Blog", "/admin/blog")
        item.children.should == []
      end

      it "should accept new children" do
        item = MenuItem.new("Blog", "/admin/blog")
        item.add "Dashboard", "/admin"
        item.children.first.should be_an_instance_of(MenuItem)
        item.children.first.name.should == "Dashboard"
      end
    end

    context "with many children" do
      let(:item) do
        i = MenuItem.new("Dashboard", "/admin")
        i.add "Blog",     "/" 
        i.add "Cars",     "/" 
        i.add "Users",    "/",  1
        i.add "Settings", "/",  2
        i.add "Analytics", "/", 44
        i
      end

      it "should give access to the menu item as an array" do
        item['Blog'].name.should == 'Blog'
      end

      it "should sort items based on priority and name" do    
        item.children[0].name.should == 'Users'
        item.children[1].name.should == 'Settings'
        item.children[2].name.should == 'Blog'
        item.children[3].name.should == 'Cars'
        item.children[4].name.should == 'Analytics'
      end

      it "children should hold a reference to their parent" do
        item["Blog"].parent.should == item
      end
    end

    describe "building children using block syntax" do
      let(:item) do
        MenuItem.new("Blog", "/") do |blog|
          blog.add "Create New", "/blog/new"
          blog.add("Comments", "/blog/comments") do |comments|
            comments.add "Approved", "/blog/comments?status=approved"
          end
        end
      end

      it "should have 2 children" do
        item.children.size.should == 2
      end

      it "should have sub-sub items" do
        item["Comments"]["Approved"].name.should == 'Approved'
      end
    end

    describe "accessing ancestory" do
      let(:item){ MenuItem.new "Blog", "/blog" }

      context "with no parent" do
        it "should return an empty array" do
         item.ancestors.should == [] 
        end
      end

      context "with one parent" do
        let(:sub_item) do 
          item.add "Create New", "/blog/new"
          item["Create New"]
        end
        it "should return an array with the parent" do
          sub_item.ancestors.should == [item]
        end
      end

      context "with many parents" do
        before(:each) do
          item.add "C1", "/c1" do |c1|
            c1.add "C2", "/c2" do |c2|
              c2.add "C3", "/c3"
            end
          end
        end
        let(:sub_item){ item["C1"]["C2"]["C3"] }
        it "should return an array with the parents in reverse order" do
          sub_item.ancestors.should == [item["C1"]["C2"], item["C1"], item]
        end
      end
    end # accessing ancestory

  end
end
