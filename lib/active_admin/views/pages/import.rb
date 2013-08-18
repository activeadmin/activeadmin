module ActiveAdmin
  module Views
    module Pages

      class Import < Base

        def title
          I18n.t 'active_admin.import.title'
        end

        def main_content
          para 'A CSV file can be used to import records. The first row should be column names. The following columns are allowed:'

          ul do
            resource_class.columns.each do |c|
              li do
                strong c.name
                text_node ' - ' + c.type.to_s.titleize
              end if c.name.in? ['id', *resource_class.accessible_attributes]
            end
          end

          para do
            text_node 'If an'
            strong 'ID'
            text_node 'is supplied it will update the matching record instead of creating a new one.'
          end

          para do
            strong 'WARNING:'
            text_node 'if you try to import more than ~10k records, the request will take a long time and might time out!'
          end

          if importer.errors.any?
            h3 pluralize(importer.errors.count, 'error') + " prohibited this import from completing:"
            ul do
              importer.errors.full_messages.each{ |m| li m }
            end
          end

          text_node active_admin_form_for(importer, url: collection_path + '/import') { |f|
            f.inputs do
              f.file_field :file
            end
            f.actions do
              f.action :submit, label: "Import"
              f.cancel_link
            end
          }
        end

      end

    end
  end
end
