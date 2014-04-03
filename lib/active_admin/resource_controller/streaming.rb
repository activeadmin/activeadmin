module ActiveAdmin
  class ResourceController < BaseController

    # This module overrides CSV responses to allow large data downloads.
    # Could be expanded to JSON and XML in the future.
    #
    module Streaming
      extend ActiveSupport::Concern

      included do
        require 'csv' unless defined?(CSV)
        include CSVStream
      end

      module CSVStream

        def index
          super { |format| format.csv { stream_csv collection } }
        end

        protected

        def csv_line(resource, columns)
          columns.map do |column|
            call_method_or_proc_on resource, column.data
          end
        end

        def stream_csv(collection)
          default = ActiveAdmin.application.csv_options
          options = default.merge active_admin_config.csv_builder.options
          columns = active_admin_config.csv_builder.render_columns(self)

          headers['Cache-Control'] = 'no-cache'

          self.response_body = Enumerator.new do |csv|
            csv << CSV.generate_line(columns.map(&:name), options)
            collection.find_each do |resource|
              csv << CSV.generate_line(csv_line(resource, columns), options)
            end
          end
        end
      end
    end
  end
end
