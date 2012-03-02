require 'spec_helper'

describe ActiveAdmin::Views::BatchActionPopover do

  setup_arbre_context!

  let(:the_popover) do
    batch_action_popover do
      action ActiveAdmin::BatchAction.new( :action_1, "Action 1" )
      action ActiveAdmin::BatchAction.new( :action_2, "Action 2" )
      action ActiveAdmin::BatchAction.new( :action_3, "Action 3" )
    end
  end
  
  it "should have an id" do
    the_popover.id.should == "batch_actions_popover"
  end
  
  describe "the action list" do
    subject do
      the_popover.find_by_class("popover_contents").first
    end

    its(:tag_name) { should eql("ul") }
    
    its(:content){ should include("<li><a href=\"#\" class=\"batch_action\" data-action=\"action_1\">Action 1 Selected</a></li>") }
    its(:content){ should include("<li><a href=\"#\" class=\"batch_action\" data-action=\"action_2\">Action 2 Selected</a></li>") }
    its(:content){ should include("<li><a href=\"#\" class=\"batch_action\" data-action=\"action_3\">Action 3 Selected</a></li>") }
    
  end

end
