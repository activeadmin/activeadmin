# Required methods:
#   * controller_class
#   * controller
#
shared_examples_for "BaseController" do
  let(:controller_class) { described_class }

  describe "PageConfig" do
    [:index, :show].each do |page|
      describe "#{page} config" do
        before do
          # By pass #active_admin_config= because it requires Config to respond 
          # to #resource in ResourceController
          controller_class.instance_variable_set(:@active_admin_config, ActiveAdmin::Config.new)
          controller_class.send(:"reset_#{page}_config!")
        end

        it "should be set" do
          controller_class.send(:set_page_config, page, {})
          controller_class.send(:"#{page}_config").should be_an_instance_of(ActiveAdmin::PageConfig)
        end

        it "should store the block" do
          block = Proc.new {}
          controller_class.send(:set_page_config, page, {}, &block)
          controller_class.send(:"#{page}_config").block.should == block
        end

        it "should be reset" do
          controller_class.send(:"reset_#{page}_config!")
          controller_class.send(:"#{page}_config").should == nil
        end
      end
    end
  end

  describe "Menu" do
    describe "setting the current tab" do
      before do 
        controller.stub!(:active_admin_config => resource, :parent? => true)
        controller.send :set_current_tab # Run the before filter
      end
      subject{ controller.instance_variable_get(:@current_tab) }

      context "when menu item name is 'Resources' without a parent menu item" do
        let(:resource){ mock(:menu_item_name => "Resources", :parent_menu_item_name => nil, :belongs_to? => false) }
        it { should == "Resources" }
      end

      context "when there is a parent menu item of 'Admin'" do
        let(:resource){ mock(:parent_menu_item_name => "Admin", :menu_item_name => "Resources", :belongs_to? => false) }
        it { should == "Admin/Resources" }
      end
    end
  end

end
