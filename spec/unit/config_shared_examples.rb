shared_examples_for "ActiveAdmin::Config" do
  describe "namespace" do
    it "should return the namespace" do
      config.namespace.should == namespace
    end
  end

  describe "page_presenters" do
    it "should return an empty hash by default" do
      config.page_presenters.should == {}
    end
  end

  it { respond_to :controller_name }
  it { respond_to :controller }
  it { respond_to :route_prefix }
  it { respond_to :route_collection_path }
  it { respond_to :comments? }
  it { respond_to :belongs_to? }
  it { respond_to :action_items? }
  it { respond_to :sidebar_sections? }

  describe "Naming" do
    it "implements #resource_label" do
      expect { config.resource_label }.should_not raise_error
    end

    it "implements #plural_resource_label" do
      expect { config.plural_resource_label }.should_not raise_error
    end
  end

  describe "Menu" do
    describe "menu item" do

	  it "initializes a new menu item with defaults" do
        config.menu_item.label.should == config.plural_resource_label
	  end

      it "initialize a new menu item with custom options" do
		config.menu :label => "Hello"
        config.menu_item.label.should == "Hello"
      end

    end

    describe "#include_in_menu?" do
      it "should be included in menu by default" do
        config.include_in_menu?.should == true
      end

      it "should not be included in menu when menu set to false" do
        config.menu false
        config.include_in_menu?.should == false
      end
    end

    describe "parent menu item name" do

      it "should be nil when not set" do
        config.parent_menu_item_name.should == nil
      end

      it "should return the name if set" do
		config.menu :parent => "Blog"
        config.parent_menu_item_name.should == "Blog"
      end

    end

  end
end
