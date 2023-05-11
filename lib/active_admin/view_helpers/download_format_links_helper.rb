# frozen_string_literal: true
module ActiveAdmin
  module ViewHelpers
    module DownloadFormatLinksHelper
      private

      def build_download_formats(download_links)
        download_links = instance_exec(&download_links) if download_links.is_a?(Proc)

        if download_links.is_a?(Array) && !download_links.empty?
          download_links
        elsif download_links == false
          []
        else
          self.class.formats
        end
      end

      def build_download_format_links(formats = self.class.formats)
        params = request.query_parameters.except :format, :commit
        div class: "download_links" do
          span I18n.t("active_admin.download")
          formats.each do |format|
            a format.upcase, href: url_for(params: params, format: format)
          end
        end
      end

      def self.included base
        base.extend ClassMethods
      end

      module ClassMethods

        # A ready only of formats to make available in index/paginated
        # collection view.
        # @return [Array]
        # @see add_format for information on adding custom download link
        # formats
        def formats
          @formats ||= [:csv, :xml, :json]
          @formats.clone
        end

        # Adds a mime type to the list of available formats available for data
        # export. You must register the extension prior to adding it here.
        # @param [Symbol] format the mime type to add
        # @return [Array] A copy of the updated formats array.
        def add_format(format)
          unless Mime::Type.lookup_by_extension format
            raise ArgumentError, "Please register the #{format} mime type with `Mime::Type.register`"
          end
          @formats << format unless formats.include? format
          formats
        end
      end

    end
  end
end
