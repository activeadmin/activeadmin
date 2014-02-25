module ActiveAdmin
  module ViewHelpers
    module DownloadFormatLinksHelper

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

        # Adds a mime type extension to the list of available formats.
        # You must register the extension prior to adding it to the list
        # of avilable formats. This should be used by plugins that want
        # to add additional formats to the download format links.
        # @param [Symbol] extension the mime extension to add
        # @return [Array] A copy of the updated formats array.
        def add_format extension
          unless formats.include?(extension)
            if Mime::Type.lookup_by_extension(extension).nil?
              raise ArgumentError, "The mime extension you defined: #{extension} is not registered. Please register it via Mime::Type.register before adding it to the available formats."
            end
          @formats << extension
          end
          formats
        end
      end

      # TODO: Refactor to new HTML DSL
      def build_download_format_links(formats = self.class.formats)
        params = request.query_parameters.except :format, :commit
        links = formats.map { |format| link_to format.to_s.upcase, params: params, format: format }
        div class: "download_links" do
          text_node [I18n.t('active_admin.download'), links].flatten.join("&nbsp;").html_safe
        end
      end

      def self.included base
        base.extend ClassMethods
      end
    end
  end
end

