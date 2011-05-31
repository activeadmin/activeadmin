# Mock out CanCan
module CanCan
  class InheritedResource
    def initialize(controller)
      @controller = controller
    end
  end
end

require 'spec_helper'

describe ActiveAdmin::CanCan do

  describe ActiveAdmin::CanCan::ControllerResource do
    it "should return the collection for cancan to use" do
      controller = mock("MockController")
      controller.should_receive(:collection)
      ActiveAdmin::CanCan::ControllerResource.new(controller).resource_base
    end
  end

end
