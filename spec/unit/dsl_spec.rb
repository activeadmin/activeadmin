require 'spec_helper'


module MockModuleToInclude
  def self.included(dsl)
  end
end

describe ActiveAdmin::DSL do

  let(:config){ mock }
  let(:dsl){ ActiveAdmin::DSL.new(config) }

  describe "#include" do

    it "should call the included class method on the module that is included" do
      MockModuleToInclude.should_receive(:included).with(dsl)
      dsl.run_registration_block do
        include MockModuleToInclude
      end
    end

  end

  describe "#menu" do

    it "should set the menu_item_options on the configuration" do
      config.should_receive(:menu_item_options=).with({:parent => "Admin"})
      dsl.run_registration_block do
        menu :parent => "Admin"
      end
    end

  end

  describe "#display_menu" do

    it "should set the display_menu_name on the configuration" do
      config.should_receive(:display_menu_name=).with(:admin)
      dsl.run_registration_block do
        display_menu :admin
      end
    end

  end

end
