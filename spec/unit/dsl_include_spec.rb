require 'spec_helper'

module MockModuleToInclude
  def self.included(dsl)
  end
end


describe ActiveAdmin::DSL, "#include" do

  let(:dsl){ ActiveAdmin::DSL.new(mock) }

  it "should call the included class method on the module that is included" do
    MockModuleToInclude.should_receive(:included).with(dsl)
    dsl.run_registration_block do
      include MockModuleToInclude
    end
  end

end
