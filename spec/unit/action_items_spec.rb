require 'spec_helper' 

describe ActiveAdmin::ActionItems do

  describe "rendering" do
    include Arbre::HTML
    let(:assigns){ {} }
    let(:action_item) do
      ActiveAdmin::ActionItems::ActionItem.new do
        h2 "Hello World"
      end
    end

    let(:rendered){ insert_tag ActiveAdmin::Views::ActionItems, [action_item]}

    it "should have a parent .action_items div" do
      rendered.tag_name.should == 'div'
      rendered.class_list.should include('action_items')
    end

    it "should render the contents of each action item" do
      rendered.children.size.should == 1
      rendered.content.strip.should == "<span class=\"action_item\">\n    <h2>Hello World</h2>\n  </span>"
    end
  end

end
