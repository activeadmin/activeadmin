require 'spec_helper' 

describe ActiveAdmin::Menu do

  context "with no items" do
    it "should be empty" do
      ActiveAdmin::Menu.new.items.should == []
    end
    
    it "should accept new items" do
      menu = ActiveAdmin::Menu.new
      menu.add "Dashboard", "/admin"
      menu.items.first.should be_an_instance_of(ActiveAdmin::MenuItem)
      menu.items.first.name.should == "Dashboard"
    end
    
    it "should default new items to the priority of 10" do
      menu = ActiveAdmin::Menu.new
      menu.add "Dashboard", "/admin"
      menu.items.first.priority.should == 10
    end
  end
  
  context "with many item" do
    let(:menu) do
      ActiveAdmin::Menu.new do |m|
        m.add "Dashboard", "/admin"
        m.add "Blog",      "/admin/blog"
        m.add "Users",     "/admin/users"
        m.add "Settings",  "/admin/settings" do |s|
          s.add "Admin Settings", "/admin/settings/admin" do |as|
            s.add "User Settings", "/admin/settings/users"
          end
        end
      end
    end

    it "should give access to the menu item as an array" do
      menu['Dashboard'].name.should == 'Dashboard'
    end
    
    it "should find the item by a url on the top level" do
      menu.find_by_url("/admin").name.should == "Dashboard"
    end
    
    it "should find the item deep in the tree" do
      menu.find_by_url("/admin/settings/users").name.should == "User Settings"
    end
    
  end

end

