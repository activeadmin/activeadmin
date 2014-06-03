require 'rails_helper'

describe ActiveAdmin::Views::IndexList do

  describe "#index_list_renderer" do


    let(:index_classes) { [ActiveAdmin::Views::IndexAsTable, ActiveAdmin::Views::IndexAsBlock] }

    let(:helpers) do
      helpers = mock_action_view
      allow(helpers).to receive(:url_for).and_return("/")
      allow(helpers).to receive(:params).and_return as: "table"
      helpers
    end

    subject do
      render_arbre_component({index_classes: index_classes}, helpers) do
        index_list_renderer(index_classes)
      end
    end

    describe '#tag_name' do
      subject { super().tag_name }
      it { is_expected.to eq 'ul'}
    end

    it "should contain the names of available indexes in links" do
      a_tags = subject.find_by_tag("a")
      expect(a_tags.size).to eq 2
      expect(a_tags.first.to_s).to include("Table")
      expect(a_tags.last.to_s).to include("List")
    end
  end
end
