# frozen_string_literal: true
module ActiveAdmin
  class Resource
    module ScopeTo

      # Scope this controller to some object which has a relation
      # to the resource. Can either accept a block or a symbol
      # of a method to call.
      #
      # Eg:
      #
      #   ActiveAdmin.register Post do
      #     scope_to :current_user
      #   end
      #
      # Then every time we instantiate and object, it would call
      #
      #   current_user.posts.build
      #
      # By default Active Admin will use the resource name to build a
      # method to call as the association. If its different, you can
      # pass in the association_method as an option.
      #
      #   scope_to :current_user, association_method: :blog_posts
      #
      # will result in the following
      #
      #   current_user.blog_posts.build
      #
      # To conditionally use this scope, you can use conditional procs
      #
      #   scope_to :current_user, if: proc{ admin_user_signed_in? }
      #
      # or
      #
      #   scope_to :current_user, unless: proc{ current_user.admin? }
      #
      def scope_to(*args, &block)
        options = args.extract_options!
        method = args.first

        scope_to_config[:method] = block || method
        scope_to_config[:association_method] = options[:association_method]
        scope_to_config[:if] = options[:if]
        scope_to_config[:unless] = options[:unless]

      end

      def scope_to_association_method
        scope_to_config[:association_method]
      end

      def scope_to_method
        scope_to_config[:method]
      end

      def scope_to_config
        @scope_to_config ||= {
          method: nil,
          association_method: nil,
          if: nil,
          unless: nil
        }
      end

      def scope_to?(context = nil)
        return false if scope_to_method.nil?
        return render_in_context(context, scope_to_config[:if]) unless scope_to_config[:if].nil?
        return !render_in_context(context, scope_to_config[:unless]) unless scope_to_config[:unless].nil?
        true
      end

    end
  end
end
