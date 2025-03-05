# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::IndexAsTable::IndexTableFor do
  describe "creating with the dsl" do
    let(:collection) do
      [Post.new(title: "First Post", starred: true)]
    end
    let(:active_admin_config) do
      namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
      namespace.batch_actions = [ActiveAdmin::BatchAction.new(:flag, "Flag") {}]
      namespace
    end

    let(:assigns) do
      {
        collection: collection,
        active_admin_config: active_admin_config,
        resource_class: User,
      }
    end
    let(:helpers) { mock_action_view }

    context "when creating a selectable column" do
      let(:table) do
        render_arbre_component assigns, helpers do
          insert_tag(ActiveAdmin::Views::IndexAsTable::IndexTableFor, collection, { sortable: true }) do
            selectable_column(class: "selectable")
          end
        end
      end

      context "creates a table header based on the selectable column" do
        let(:header) do
          table.find_by_tag("th").first
        end

        it "with selectable column class name" do
          expect(header.attributes[:class]).to include "selectable"
        end

        it "not sortable" do
          expect(header.attributes).not_to include("data-sortable": "")
        end
      end
    end

    context "when creating an id column" do
      before { allow(helpers).to receive(:url_target) { 'routing_stub' } }

      def build_index_table(&block)
        render_arbre_component assigns, helpers do
          insert_tag(ActiveAdmin::Views::IndexAsTable::IndexTableFor, collection, { sortable: true }) do
            instance_exec(&block)
          end
        end
      end

      it "use primary key as title by default" do
        table = build_index_table { id_column }
        header = table.find_by_tag("th").first
        expect(header.content).to include("id")
      end

      it "supports title customization" do
        table = build_index_table { id_column 'Res. Id' }
        header = table.find_by_tag("th").first
        expect(header.content).to include("Res. Id")
      end

      it "is sortable by default" do
        table = build_index_table { id_column }
        header = table.find_by_tag("th").first
        expect(header.attributes).to include("data-sortable": "")
      end

      it "supports sortable: false" do
        table = build_index_table { id_column sortable: false }
        header = table.find_by_tag("th").first
        expect(header.attributes).not_to include("data-sortable": "")
      end

      it "supports sortable column names" do
        table = build_index_table { id_column sortable: :created_at }
        header = table.find_by_tag("th").first
        expect(header.attributes).to include("data-sortable": "")
      end

      it 'supports title customization and options' do
        table = build_index_table { id_column 'Res. Id', sortable: :created_at }
        header = table.find_by_tag("th").first
        expect(header.content).to include("Res. Id")
        expect(header.attributes).to include("data-sortable": "")
      end
    end
  end
end
