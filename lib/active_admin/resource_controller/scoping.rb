module ActiveAdmin
  class ResourceController < BaseController

    # This module deals with scoping entire controllers to a relation
    module Scoping
      extend ActiveSupport::Concern

      protected

      # Override the default InheritedResource #begin_of_association_chain to allow
      # the scope to be defined in the active admin configuration.
      #
      # If scope_to is a proc, we eval it, otherwise we call the method on the controller.
      #
      # Collection can be scoped conditionally with an :if or :unless proc.
      def begin_of_association_chain
        return nil unless active_admin_config.scope_to?(self)
        render_in_context(self, active_admin_config.scope_to_method)
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
