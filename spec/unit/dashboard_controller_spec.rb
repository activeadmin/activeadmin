require 'spec_helper' 


module Admin
  class DashboardController < ActiveAdmin::Dashboards::DashboardController
  end
end
class DashboardController < ActiveAdmin::Dashboards::DashboardController; end

describe ActiveAdmin::Dashboards::DashboardController do

  describe "getting the namespace name" do
    subject{ controller.send :namespace }

    context "when admin namespace" do
      let(:controller){ Admin::DashboardController.new }
      it { should == :admin }
    end

    context "when root namespace" do
      let(:controller){ DashboardController.new }
      it { should == :root }
    end
  end

end
