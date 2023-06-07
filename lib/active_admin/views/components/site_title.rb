# frozen_string_literal: true
module ActiveAdmin
  module Views

    class SiteTitle < Component

      def tag_name
        "h1"
      end

      def build(namespace)
        super(id: "site_title")
        @namespace = namespace

        if site_title_link?
          text_node site_title_with_link
        else
          text_node site_title_content
        end
      end

      def site_title_link?
        @namespace.site_title_link.present?
      end

      def site_title_image
        @site_title_image ||= @namespace.site_title_image(helpers)
      end

      private

      def site_title_with_link
        helpers.link_to(site_title_content, @namespace.site_title_link)
      end

      def site_title_content
        if site_title_image.present?
          title_image
        else
          title_text
        end
      end

      def title_text
        @title_text ||= @namespace.site_title(helpers)
      end

      def title_image
        helpers.image_tag(site_title_image, id: "site_title_image", alt: title_text)
      end

    end

  end
end
