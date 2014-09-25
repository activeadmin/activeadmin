require 'rails_helper'

describe ActiveAdmin::Views::IndexAsTable::IndexTableFor do
  describe 'creating with the dsl' do
    let(:collection) do
      [Post.new(title: 'First Post', starred: true)]
    end
    let(:active_admin_config) do
      namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
      namespace.batch_actions = [ActiveAdmin::BatchAction.new(:flag, 'Flag') {}]
      namespace
    end

    let(:assigns) do
      {
        collection: collection,
        active_admin_config: active_admin_config
      }
    end
    let(:helpers) { mock_action_view }

    context 'when creating a selectable column' do
      let(:table) do
        render_arbre_component assigns, helpers do
          insert_tag(ActiveAdmin::Views::IndexAsTable::IndexTableFor, collection, {sortable: true}) do
            selectable_column
          end
        end
      end

      context 'creates a table header based on the selectable column' do
        let(:header) do
          table.find_by_tag('th').first
        end

        it 'with selectable column class name' do
          expect(header.attributes[:class]).to include 'col-selectable'
        end

        it 'not sortable' do
          expect(header.attributes[:class]).not_to include 'sortable'
        end
      end
    end
  end
end