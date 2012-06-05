require 'spec_helper' 

require 'active_admin/dashboards/dashboard_controller'
require 'active_admin/dashboards/section'

module Admin
  class TestDashboardController < ActiveAdmin::PageController
    include ActiveAdmin::Dashboards::DashboardController
  end
end

class TestDashboardController < ActiveAdmin::PageController
  include ActiveAdmin::Dashboards::DashboardController
end

describe ActiveAdmin::Dashboards::DashboardController do

  describe "getting the namespace name" do
    subject{ controller.send :namespace }

    context "when admin namespace" do
      let(:controller){ Admin::TestDashboardController.new }
      it { should == :admin }
    end

    context "when root namespace" do
      let(:controller){ TestDashboardController.new }
      it { should == :root }
    end
  end

  describe "conditionally displaying sections" do
    before { ActiveAdmin::Dashboards.clear_all_sections! }
    let(:controller){ Admin::TestDashboardController.new }
    
    context "when :if not specified" do
      before do
        @section = ActiveAdmin::Dashboards.add_section('Stats').last
      end
      
      it "should include section" do
        controller.send(:find_sections).should include(@section)
      end
    end
    
    context "when :if option specified as a method" do
      before do
        @section = ActiveAdmin::Dashboards.add_section('Secret Codes', :if => :i_am_awesome?).last
      end
      
      it "should call the method of the same name" do
        controller.should_receive(:i_am_awesome?).and_return(true)
        controller.send(:find_sections).should include(@section)
        
        controller.should_receive(:i_am_awesome?).and_return(false)
        controller.send(:find_sections).should_not include(@section)
      end
    end
    
    context "when :if option specified as block" do
      before do
        @proc    = Proc.new { true }
        @section = ActiveAdmin::Dashboards.add_section('Secret Codes', :if => proc {}).last
      end
      
      it "should evaluate the block" do
        controller.should_receive(:instance_exec).with(&@proc).and_return(true)
        controller.send(:find_sections).should include(@section)
        
        controller.should_receive(:instance_exec).with(&@proc).and_return(false)
        controller.send(:find_sections).should_not include(@section)
      end
    end
  end
  
end
