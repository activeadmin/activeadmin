require 'spec_helper'

describe ActiveAdmin::Views::IndexList do

  describe "#index_list_renderer" do


    let(:index_classes) { [ActiveAdmin::Views::IndexAsTable, ActiveAdmin::Views::IndexAsBlock] }

    let(:helpers) do
      helpers = mock_action_view
      helpers.stub! :url_for => "/"
      helpers.stub!(:params).and_return({:as => "table"})
      helpers
    end

    subject do
      render_arbre_component({:index_classes => index_classes}, helpers) do
        index_list_renderer(index_classes)
      end
    end

    its(:tag_name) { should == 'ul' }

    it "should contain the names of available indexes in links" do
      a_tags = subject.find_by_tag("a")
      a_tags.size.should == 2
      a_tags.first.to_s.should include("Table")
      a_tags.last.to_s.should include("List")
    end
  end
end
