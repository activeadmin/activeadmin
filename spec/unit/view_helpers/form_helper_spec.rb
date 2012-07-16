require 'spec_helper'

describe ActiveAdmin::ViewHelpers::FormHelper do
  describe ".hidden_field_tags_for" do
    let(:view) { action_view }

    it "should render hidden field tags for params" do
      view.hidden_field_tags_for(scope: "All", filter: "None").should == 
        %{<input id="scope" name="scope" type="hidden" value="All" />\n<input id="filter" name="filter" type="hidden" value="None" />}
    end
  end
end

