# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::IndexList do
  let(:custom_index_as) do
    Class.new(ActiveAdmin::Component) do
      def build(page_presenter, collection)
        add_class "index"
        resource_selection_toggle_panel if active_admin_config.batch_actions.any?
        collection.each do |obj|
          instance_exec(obj, &page_presenter.block)
        end
      end

      def self.index_name
        "custom"
      end
    end
  end

  describe "#index_list_renderer" do
    let(:index_classes) { [ActiveAdmin::Views::IndexAsTable, custom_index_as] }

    let(:collection) do
      Post.create(title: "First Post", starred: true)
      Post.where(nil)
    end

    let(:helpers) do
      helpers = mock_action_view
      allow(helpers).to receive(:url_for) { |url| "/?#{ url.to_query }" }
      allow(helpers.request).to receive(:query_parameters).and_return as: "table", q: { title_cont: "terms" }
      allow(helpers).to receive(:params).and_return(ActionController::Parameters.new(as: "table", q: { title_cont: "terms" }))
      allow(helpers).to receive(:collection).and_return(collection)
      helpers
    end

    subject do
      render_arbre_component({ index_classes: index_classes }, helpers) do
        insert_tag(ActiveAdmin::Views::IndexList, index_classes)
      end
    end

    describe "#tag_name" do
      subject { super().tag_name }
      it { is_expected.to eq "div" }
    end

    it "should contain the names of available indexes in links" do
      a_tags = subject.find_by_tag("a")
      expect(a_tags.size).to eq 2
      expect(a_tags.first.to_s).to include("Table")
      expect(a_tags.last.to_s).to include("Custom")
    end

    it "should maintain index filter parameters" do
      a_tags = subject.find_by_tag("a")
      expect(a_tags.first.attributes[:href])
        .to eq("/?#{ { as: "table", q: { title_cont: "terms" } }.to_query }")
      expect(a_tags.last.attributes[:href])
        .to eq("/?#{ { as: "custom", q: { title_cont: "terms" } }.to_query }")
    end
  end
end
