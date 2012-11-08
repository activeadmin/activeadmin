module ActiveAdmin
  module Comments

    # Adds #active_admin_comments to the show page for use
    # and sets it up on the default main content
    module ShowPageHelper

      # Add admin comments to the main content if they are
      # turned on for the current resource
      def default_main_content
        super
        active_admin_comments if active_admin_config.comments?
      end

      def comments_table_exists?
         @val ||= ActiveRecord::Base.connection.tables.include?("active_admin_comments")
      end

      # Display the comments for the resource. Same as calling
      # #active_admin_comments_for with the current resource
      def active_admin_comments(*args, &block)
        if comments_table_exists?
          active_admin_comments_for(resource, *args, &block)
        end
      end
    end

  end
end
