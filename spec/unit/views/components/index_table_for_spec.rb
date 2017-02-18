require 'rails_helper'

RSpec.describe ActiveAdmin::Views::IndexAsTable::IndexTableFor do
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

    context 'when creating an index column' do
      let(:base_collection) do
        posts = [
          Post.new(title: 'First Post', starred: true),
          Post.new(title: 'Second Post', starred: true),
          Post.new(title: 'Third Post', starred: true),
          Post.new(title: 'Fourth Post', starred: true)
        ]
        Kaminari.paginate_array(posts, limit: 2)
      end
      let(:collection) do
        base_collection.page(1)
      end

      let(:table) do
        render_arbre_component assigns, helpers do
          insert_tag(ActiveAdmin::Views::IndexAsTable::IndexTableFor, collection, {sortable: true}) do
            index_column
          end
        end
      end

      context 'creates a table header based on the index column' do
        let(:header) do
          table.find_by_tag('th').first
        end

        it 'with index column class name' do
          expect(header.attributes[:class]).to include 'col-index'
        end

        it 'not sortable' do
          expect(header.attributes[:class]).not_to include 'sortable'
        end
      end

      context 'verifying the indices for the rows' do
        let(:index_values) do
          table.find_by_tag('tr').map do |row|
            next unless row.find_by_tag('td').first
            row.find_by_tag('td').first.content
          end.compact
        end

        context 'viewing the first page' do
          it 'shows the correct indices' do
            expect(index_values).to eq(['1', '2'])
          end
        end
        context 'viewing the second page' do
          let(:collection) do
            base_collection.page(2)
          end
          it 'shows the correct indices' do
            expect(index_values).to eq(['3', '4'])
          end
        end
      end

      context 'allows for zero-based indices' do
        let(:table) do
          render_arbre_component assigns, helpers do
            insert_tag(ActiveAdmin::Views::IndexAsTable::IndexTableFor, collection, {sortable: true}) do
              index_column(0)
            end
          end
        end

        let(:index_values) do
          table.find_by_tag('tr').map do |row|
            next unless row.find_by_tag('td').first
            row.find_by_tag('td').first.content
          end.compact
        end

        it 'shows the correct indices' do
          expect(index_values).to eq(['0', '1'])
        end
      end
    end
  end
end
