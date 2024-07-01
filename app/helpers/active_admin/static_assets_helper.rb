# frozen_string_literal: true

module ActiveAdmin
  module StaticAssetsHelper
    def static_stylesheet_link_tag(name)
      tag.link(rel: :stylesheet, href: "#{static_assets_path}/css/#{name}.css")
    end

    def static_javascript_importmap_tags(...)
      Resolver.new(request, self, static_assets_path).javascript_importmap_tags(...)
    end

    def static_assets_path
      ActiveAdmin.application.static_assets_path
    end

    # resolves importmaps to static paths
    Resolver = Struct.new(:request, :default, :root) do
      include ActionView::Helpers::TagHelper
      include Importmap::ImportmapTagsHelper if defined?(Importmap::ImportmapTagsHelper)

      def path_to_asset(path, ...)
        # Don't try to use static assets for custom additions to importmap
        unless path.match?(%r{\A(?:active_admin|flowbite|rails_ujs_esm)[/.]})
          return default.asset_path(path, ...)
        end

        "#{root}/js/#{path}"
      end
    end
  end
end
