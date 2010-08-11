module ActiveAdmin

  # Member Actions give you the functionality of defining both the
  # action and the route directly from your ActiveAdmin registration
  # block.
  #
  # For example:
  #
  #   ActiveAdmin.register Post do
  #     member_action :comments do
  #       @post = Post.find(params[:id]
  #       @comments = @post.comments
  #     end
  #   end
  #
  # Will create a new controller action comments and will hook it up to
  # the named route (comments_admin_post_path) /admin/posts/:id/comments
  #
  # You can treat everything within the block as a standard Rails controller
  # action.
  # 
  module ActionBuilder

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def member_action(name, options = {}, &block)
        active_admin_config.member_actions << ControllerAction.new(name, options)
        define_method(name, &block)
      end

      def clear_member_actions!
        active_admin_config.clear_member_actions!
      end


      def collection_action(name, options = {}, &block)
        active_admin_config.collection_actions << ControllerAction.new(name, options)
        define_method(name, &block)
      end

      def clear_collection_actions!
        active_admin_config.clear_collection_actions!
      end
    end

    class ControllerAction
      attr_reader :name
      def initialize(name, options = {})
        @name, @options = name, options
      end

      def http_verb
        @options[:method] ||= :get
      end
    end
  end
end
