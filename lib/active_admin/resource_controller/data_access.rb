# frozen_string_literal: true
module ActiveAdmin
  class ResourceController < BaseController

    # This module overrides most of the data access methods in Inherited
    # Resources to provide Active Admin with it's data.
    #
    # The module also deals with authorization and resource callbacks.
    #
    module DataAccess

      def self.included(base)
        base.class_exec do
          include Callbacks
          include ScopeChain

          define_active_admin_callbacks :build, :create, :update, :save, :destroy

          helper_method :current_scope
        end
      end

      protected

      COLLECTION_APPLIES = [
        :authorization_scope,
        :sorting,
        :filtering,
        :scoping,
        :includes,
        :pagination,
        :collection_decorator
      ].freeze

      # Retrieve, memoize and authorize the current collection from the db. This
      # method delegates the finding of the collection to #find_collection.
      #
      # Once #collection has been called, the collection is available using
      # either the @collection instance variable or an instance variable named
      # after the resource that the collection is for. eg: Post => @post.
      #
      # @return [ActiveRecord::Relation] The collection for the index
      def collection
        get_collection_ivar || begin
          collection = find_collection
          authorize! Authorization::READ, active_admin_config.resource_class
          set_collection_ivar collection
        end
      end

      # Does the actual work of retrieving the current collection from the db.
      # This is a great method to override if you would like to perform
      # some additional db # work before your controller returns and
      # authorizes the collection.
      #
      # @return [ActiveRecord::Relation] The collection for the index
      def find_collection(options = {})
        collection = scoped_collection
        collection_applies(options).each do |applyer|
          collection = send("apply_#{applyer}", collection)
        end
        collection
      end

      # Override this method in your controllers to modify the start point
      # of our searches and index.
      #
      # This method should return an ActiveRecord::Relation object so that
      # the searching and filtering can be applied on top
      #
      # Note, unless you are doing something special, you should use the
      # scope_to method from the Scoping module instead of overriding this
      # method.
      def scoped_collection
        end_of_association_chain
      end

      # Retrieve, memoize and authorize a resource based on params[:id]. The
      # actual work of finding the resource is done in #find_resource.
      #
      # This method is used on all the member actions:
      #
      #   * show
      #   * edit
      #   * update
      #   * destroy
      #
      # @return [ActiveRecord::Base] An active record object
      def resource
        get_resource_ivar || begin
          resource = find_resource
          resource = apply_decorations(resource)
          authorize_resource! resource

          set_resource_ivar resource
        end
      end

      # Does the actual work of finding a resource in the database. This
      # method uses the finder method as defined in InheritedResources.
      #
      # @return [ActiveRecord::Base] An active record object.
      def find_resource
        scoped_collection.send method_for_find, params[:id]
      end

      # Builds, memoize and authorize a new instance of the resource. The
      # actual work of building the new instance is delegated to the
      # #build_new_resource method.
      #
      # This method is used to instantiate and authorize new resources in the
      # new and create controller actions.
      #
      # @return [ActiveRecord::Base] An un-saved active record base object
      def build_resource
        get_resource_ivar || begin
          resource = build_new_resource
          resource = apply_decorations(resource)
          resource = assign_attributes(resource, resource_params)
          run_build_callbacks resource
          authorize_resource! resource

          set_resource_ivar resource
        end
      end

      # Builds a new resource. This method uses the method_for_build provided
      # by Inherited Resources.
      #
      # @return [ActiveRecord::Base] An un-saved active record base object
      def build_new_resource
        apply_authorization_scope(scoped_collection).send(
          method_for_build,
          *resource_params.map { |params| params.slice(active_admin_config.resource_class.inheritance_column) }
        )
      end

      # Calls all the appropriate callbacks and then creates the new resource.
      #
      # @param [ActiveRecord::Base] object The new resource to create
      #
      # @return [void]
      def create_resource(object)
        run_create_callbacks object do
          save_resource(object)
        end
      end

      # Calls all the appropriate callbacks and then saves the new resource.
      #
      # @param [ActiveRecord::Base] object The new resource to save
      #
      # @return [void]
      def save_resource(object)
        run_save_callbacks object do
          object.save
        end
      end

      # Update an object with the given attributes. Also calls the appropriate
      # callbacks for update action.
      #
      # @param [ActiveRecord::Base] object The instance to update
      #
      # @param [Array] attributes An array with the attributes in the first position
      #                           and the Active Record "role" in the second. The role
      #                           may be set to nil.
      #
      # @return [void]
      def update_resource(object, attributes)
        object = assign_attributes(object, attributes)

        run_update_callbacks object do
          save_resource(object)
        end
      end

      # Destroys an object from the database and calls appropriate callbacks.
      #
      # @return [void]
      def destroy_resource(object)
        run_destroy_callbacks object do
          object.destroy
        end
      end

      #
      # Collection Helper Methods
      #

      # Gives the authorization library a change to pre-scope the collection.
      #
      # In the case of the CanCan adapter, it calls `#accessible_by` on
      # the collection.
      #
      # @param [ActiveRecord::Relation] collection The collection to scope
      #
      # @return [ActiveRecord::Relation] a scoped collection of query
      def apply_authorization_scope(collection)
        action_name = action_to_permission(params[:action])
        active_admin_authorization.scope_collection(collection, action_name)
      end

      def apply_sorting(chain)
        params[:order] ||= active_admin_config.sort_order
        order_clause = active_admin_config.order_clause.new(active_admin_config, params[:order])

        if order_clause.valid?
          order_clause.apply(chain)
        else
          chain # just return the chain
        end
      end

      def split_search_params(params)
        params.keys.each do |key|
          if key.ends_with? "_any" or key.ends_with? "_all"
            params[key] = params[key].split  # turn into array
          end
        end
        params
      end

      # Applies any Ransack search methods to the currently scoped collection.
      # Both `search` and `ransack` are provided, but we use `ransack` to prevent conflicts.
      def apply_filtering(chain)
        @search = chain.ransack split_search_params (params[:q] || {})
        @search.result
      end

      def apply_scoping(chain)
        @collection_before_scope = chain

        if current_scope
          scope_chain(current_scope, chain)
        else
          chain
        end
      end

      def apply_includes(chain)
        if active_admin_config.includes.any?
          chain.includes *active_admin_config.includes
        else
          chain
        end
      end

      def collection_before_scope
        @collection_before_scope
      end

      def current_scope
        @current_scope ||= if params[:scope]
                             active_admin_config.get_scope_by_id(params[:scope])
                           else
                             active_admin_config.default_scope(self)
                           end
      end

      def apply_pagination(chain)
        # skip pagination if already was paginated by scope
        return chain if chain.respond_to?(:total_pages)
        page_method_name = Kaminari.config.page_method_name
        page = params[Kaminari.config.param_name]

        chain.public_send(page_method_name, page).per(per_page)
      end

      def collection_applies(options = {})
        only = Array(options.fetch(:only, COLLECTION_APPLIES))
        except = Array(options.fetch(:except, []))

        COLLECTION_APPLIES & only - except
      end

      def per_page
        if active_admin_config.paginate
          dynamic_per_page || configured_per_page
        else
          active_admin_config.max_per_page
        end
      end

      def dynamic_per_page
        params[:per_page] || @per_page
      end

      def configured_per_page
        Array(active_admin_config.per_page).first
      end

      # @param resource [ActiveRecord::Base]
      # @param attributes [Array<Hash]
      # @return [ActiveRecord::Base] resource
      #
      def assign_attributes(resource, attributes)
        if resource.respond_to?(:assign_attributes)
          resource.assign_attributes(*attributes)
        else
          resource.attributes = attributes[0]
        end

        resource
      end

      # @param resource [ActiveRecord::Base]
      # @return [ActiveRecord::Base] resource
      #
      def apply_decorations(resource)
        apply_decorator(resource)
      end

      # @return [String]
      def smart_resource_url
        if create_another?
          new_resource_url(create_another: params[:create_another])
        else
          super
        end
      end

      private

      # @return [Boolean] true if user requested to create one more
      #   resource after creating this one.
      def create_another?
        params[:create_another].present?
      end
    end
  end
end
