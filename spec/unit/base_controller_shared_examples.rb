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
