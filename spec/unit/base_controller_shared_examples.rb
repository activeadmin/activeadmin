# Required methods:
#   * controller_class
#   * controller
#
shared_examples_for "BaseController" do
  let(:controller_class) { described_class }

  describe "Menu" do
    describe "setting the current tab" do
      before do 
        controller.stub!(:active_admin_config => resource, :parent? => true)
        controller.send :set_current_tab # Run the before filter
      end
      subject{ controller.instance_variable_get(:@current_tab) }

      context "when menu item name is 'Resources' without a parent menu item" do
        let(:menu_item){ stub }
        let(:resource){ mock(:menu_item => menu_item, :parent_menu_item_name => nil, :belongs_to? => false) }
        it { should == menu_item }
      end

    end
  end

end
