shared_examples_for "ActiveAdmin::Config" do
  describe "namespace" do
    it "should return the namespace" do
      config.namespace.should == namespace
    end
  end

  describe "page_configs" do
    it "should return an empty hash by default" do
      config.page_configs.should == {}
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

    it "implements #underscored_resource_name" do
      expect { config.underscored_resource_name }.should_not raise_error
    end

    describe "#camelized_resource_name" do
      it "returns the underscored_resource_name camelized" do
        config.should_receive(:underscored_resource_name).and_return "my_resource"
        config.camelized_resource_name.should == "MyResource"
      end
    end

    describe "#plural_underscored_resource_name" do
      it "returns the plural_resource_name underscored" do
        config.should_receive(:plural_resource_name).and_return "My Resources"
        config.plural_underscored_resource_name.should == "my_resources"
      end
    end
  end
end
