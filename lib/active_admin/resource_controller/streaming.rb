require 'csv'

module ActiveAdmin
  class ResourceController < BaseController

    # This module overrides CSV responses to allow large data downloads.
    # Could be expanded to JSON and XML in the future.
    #
    module Streaming

      def index
        super { |format| format.csv { stream_csv } }
      end

      protected

      def stream_resource(&block)
        headers['X-Accel-Buffering'] = 'no'
        headers['Cache-Control'] = 'no-cache'
        self.response_body = Enumerator.new &block
      end

      def stream_csv
        stream_resource &active_admin_config.csv_builder.method(:build).to_proc.curry[self]
      end

    end
  end
end
