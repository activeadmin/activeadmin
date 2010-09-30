module ActiveAdmin
  class ResourceController < ::InheritedViews::Base

    # This module deals with scoping entire controllers to a relation
    module Scoping
      extend ActiveSupport::Concern

      module ClassMethods

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
        #   scope_to :current_user, :association_method => :blog_posts
        #
        # will result in the following
        # 
        #   current_user.blog_posts.build
        #
        def scope_to(*args, &block)
          options = args.extract_options!
          method = args.first

          active_admin_config.scope_to = block_given? ? block : method
          active_admin_config.scope_to_association_method = options[:association_method]
        end
      end

      protected

      # Override the default InheritedResource #begin_of_association_chain to allow
      # the scope to be defined in the active admin configuration.
      #
      # If scope_to is a proc, we eval it, otherwise we call the method on the controller.
      def begin_of_association_chain
        return nil unless active_admin_config.scope_to
        case active_admin_config.scope_to
        when Proc
          instance_eval &active_admin_config.scope_to
        when Symbol
          send active_admin_config.scope_to
        else
          raise ArgumentError, "#scope_to accepts a symbol or a block"
        end
      end

      # Overriding from InheritedResources::BaseHelpers
      #
      # Returns the method for the association chain when using
      # the scope_to option
      def method_for_association_chain
        active_admin_config.scope_to_association_method || super
      end

    end
  end
end
