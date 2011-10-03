require 'spec_helper'

describe ActiveAdmin::Views::ActionListPopover do

  setup_arbre_context!

  let(:the_popover) do
    action_list_popover :id => "my_awesome_action_list_popover" do
      action "Action 1", "#"
      action "Action 2", "#"
      action "Action 3", "#"
    end
  end
  
  it "should have an id" do
    the_popover.id.should == "my_awesome_action_list_popover"
  end
  
  describe "the action list" do
    subject do
      the_popover.find_by_class("popover_contents").first
    end

    its(:tag_name) { should eql("ul") }
    
    its(:content){ should include("<li><a href=\"#\">Action 1</a></li>") }
    its(:content){ should include("<li><a href=\"#\">Action 2</a></li>") }
    its(:content){ should include("<li><a href=\"#\">Action 3</a></li>") }
    
  end

end
