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
    it "implements #resource_name" do
      expect { config.resource_name }.should_not raise_error
    end

    it "implements #plural_resource_name" do
      expect { config.plural_resource_name }.should_not raise_error
    end

    describe "#camelized_resource_name" do
      it "returns a camelized version of the resource_name" do
        config.should_receive(:resource_name).and_return "My resource"
        config.camelized_resource_name.should == "MyResource"
      end
    end

    describe "#underscored_resource_name" do
      it "returns the camelized_resource_name underscored" do
        config.should_receive(:camelized_resource_name).and_return "MyResource"
        config.underscored_resource_name.should == "my_resource"
      end
    end

    describe "#plural_underscored_resource_name" do
      it "returns the plural_camelized_resource_name underscored" do
        config.should_receive(:plural_camelized_resource_name).and_return "MyResources"
        config.plural_underscored_resource_name.should == "my_resources"
      end
    end
  end

  describe "Menu" do
    describe "menu item name" do
      it "should be the plural resource name when not set" do
        config.menu_item_name.should == config.plural_resource_name
      end
      it "should be settable" do
        config.menu :label => "My Label"
        config.menu_item_name.should == "My Label"
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
        config.tap do |c|
          c.menu :parent => "Blog"
        end.parent_menu_item_name.should == "Blog"
      end
    end

    describe "menu item priority" do
      it "should be 10 when not set" do
        config.menu_item_priority.should == 10
      end
      it "should be settable" do
        config.menu :priority => 2
        config.menu_item_priority.should == 2
      end
    end

    describe "menu item display if" do
      it "should be a proc always returning true if not set" do
        config.menu_item_display_if.should be_instance_of(Proc)
        config.menu_item_display_if.call.should == true
      end
      it "should be settable" do
        config.menu :if => proc { false }
        config.menu_item_display_if.call.should == false
      end
    end
  end
end
