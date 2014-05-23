require 'csv'

module ActiveAdmin
  class ResourceController < BaseController

    # This module overrides CSV responses to allow large data downloads.
    # Could be expanded to JSON and XML in the future.
    #
    module Streaming

      def index
        super { |format| format.csv { stream_csv collection } }
      end

      protected

      def csv_line(resource, columns, options)
        columns.map do |column|
          s = call_method_or_proc_on resource, column.data

          if options[:encoding] && s.respond_to?(:encode!)
            s.encode! options[:encoding], options[:encoding_options]
          else
            s
          end
        end
      end

      def stream_csv(collection)
        default = ActiveAdmin.application.csv_options
        options = default.merge active_admin_config.csv_builder.options
        columns = active_admin_config.csv_builder.render_columns(self)

        headers['X-Accel-Buffering'] = 'no'
        headers['Cache-Control'] = 'no-cache'

        self.response_body = Enumerator.new do |csv|
          csv << CSV.generate_line(columns.map(&:name), options)
          collection.find_each do |resource|
            csv << CSV.generate_line(csv_line(resource, columns, options), options)
          end
        end
      end

    end
  end
end
