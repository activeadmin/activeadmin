require 'rails_helper'

RSpec.describe ActiveAdmin::Views::IndexList do

  describe "#index_list_renderer" do

    let(:index_classes) { [ActiveAdmin::Views::IndexAsTable, ActiveAdmin::Views::IndexAsBlock] }

    let(:collection) {
      Post.create(title: 'First Post', starred: true)
      Post.where(nil)
    }

    let(:helpers) do
      helpers = mock_action_view
      allow(helpers).to receive(:url_for) { |url| "/?#{ url.to_query }" }
      allow(helpers.request).to receive(:query_parameters).and_return as: "table", q: { title_contains: "terms" }
      allow(helpers).to receive(:params).and_return(ActionController::Parameters.new(as: "table", q: { title_contains: "terms" }))
      allow(helpers).to receive(:collection).and_return(collection)
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

    it "should maintain index filter parameters" do
      a_tags = subject.find_by_tag("a")
      expect(a_tags.first.attributes[:href])
        .to eq("/?#{ { as: "table", q: { title_contains: "terms" } }.to_query }")
      expect(a_tags.last.attributes[:href])
        .to eq("/?#{ { as: "block", q: { title_contains: "terms" } }.to_query }")
    end
  end
end
