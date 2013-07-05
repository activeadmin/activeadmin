module ActiveAdmin
  class ResourceController < BaseController

    # This module overrides most of the data access methods in Inherited
    # Resources to provide Active Admin with it's data.
    #
    # The module also deals with authorization and resource callbacks.
    #
    module DataAccess
      extend ActiveSupport::Concern

      include ActiveAdmin::Callbacks
      include ActiveAdmin::ScopeChain

      included do
        define_active_admin_callbacks :build, :create, :update, :save, :destroy
      end

      protected

      # Retrieve, memoize and authorize the current collection from the db. This
      # method delegates the finding of the collection to #find_collection.
      #
      # Once #collection has been called, the collection is available using
      # either the @collection instance variable or an instance variable named
      # after the resource that the collection is for. eg: Post => @post.
      #
      # @returns [ActiveRecord::Relation] The collection for the index
      def collection
        _collection = get_collection_ivar

        return _collection if _collection

        _collection = find_collection
        authorize! ActiveAdmin::Authorization::READ, active_admin_config.resource_class

        set_collection_ivar _collection
      end


      # Does the actual work of retrieving the current collection from the db.
      # This is a great method to override if you would like to perform
      # some additional db # work before your controller returns and
      # authorizes the collection.
      #
      # @returns [ActiveRecord::Relation] The collectin for the index
      def find_collection
        collection = scoped_collection

        collection = apply_authorization_scope(collection)
        collection = apply_sorting(collection)
        collection = apply_filtering(collection)
        collection = apply_scoping(collection)
        collection = apply_pagination(collection)
        collection = apply_decorator(collection)

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
      # @returns [ActiveRecord::Base] An active record object
      def resource
        _resource = get_resource_ivar

        return _resource if _resource

        _resource = find_resource
        authorize_resource! _resource

        if decorator?
          _resource = decorator_class.new(_resource)
        end

        set_resource_ivar(_resource)
      end

      def decorator?
        !!active_admin_config.decorator_class
      end

      def decorator_class
        active_admin_config.decorator_class
      end


      # Does the actual work of finding a resource in the database. This
      # method uses the finder method as defined in InheritedResources.
      #
      # @returns [ActiveRecord::Base] An active record object.
      def find_resource
        scoped_collection.send(method_for_find, params[:id])
      end


      # Builds, memoize and authorize a new instance of the resource. The
      # actual work of building the new instance is delegated to the
      # #build_new_resource method.
      #
      # This method is used to instantiate and authorize new resources in the
      # new and create controller actions.
      #
      # @returns [ActiveRecord::Base] An un-saved active record base object
      def build_resource
        return resource if resource = get_resource_ivar

        resource = build_new_resource

        run_build_callbacks resource
        authorize_resource! resource

        set_resource_ivar(resource)
      end

      # Builds a new resource. This method uses the method_for_build provided
      # by Inherited Resources.
      #
      # @returns [ActiveRecord::Base] An un-saved active record base object
      def build_new_resource
        scoped_collection.send(method_for_build, *resource_params)
      end

      # Calls all the appropriate callbacks and then creates the new resource.
      #
      # @param [ActiveRecord::Base] object The new resource to create
      #
      # @returns [void]
      def create_resource(object)
        run_create_callbacks object do
          save_resource(object)
        end
      end

      # Calls all the appropriate callbacks and then saves the new resource.
      #
      # @param [ActiveRecord::Base] object The new resource to save
      #
      # @returns [void]
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
      # @returns [void]
      def update_resource(object, attributes)
        if object.respond_to?(:assign_attributes)
          object.assign_attributes(*attributes)
        else
          object.attributes = attributes[0]
        end

        run_update_callbacks object do
          save_resource(object)
        end
      end

      # Destroys an object from the database and calls appropriate callbacks.
      #
      # @returns [void]
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
      # @retruns [ActiveRecord::Relation] a scoped collection of query
      def apply_authorization_scope(collection)
        action_name = action_to_permission(params[:action])
        active_admin_authorization.scope_collection(collection, action_name)
      end


      def apply_sorting(chain)
        params[:order] ||= active_admin_config.sort_order
        if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
          column = $1
          order  = $2
          table  = active_admin_config.resource_column_names.include?(column) ? active_admin_config.resource_table_name : nil
          table_column = (column =~ /\./) ? column :
            [table, active_admin_config.resource_quoted_column_name(column)].compact.join(".")

          chain.reorder("#{table_column} #{order}")
        else
          chain # just return the chain
        end
      end

      # Applies any Ransack search methods to the currently scoped collection.
      # Both `search` and `ransack` are provided, but we use `ransack` to prevent conflicts.
      def apply_filtering(chain)
        @search = chain.ransack clean_search_params params[:q]
        @search.result
      end

      def clean_search_params(search_params)
        return {} unless search_params.is_a?(Hash)
        search_params = search_params.dup
        search_params.delete_if do |key, value|
          value == ""
        end
        search_params
      end

      def apply_scoping(chain)
        @collection_before_scope = chain

        if current_scope
          scope_chain(current_scope, chain)
        else
          chain
        end
      end

      def collection_before_scope
        @collection_before_scope
      end

      def current_scope
        @current_scope ||= if params[:scope]
          active_admin_config.get_scope_by_id(params[:scope]) if params[:scope]
        else
          active_admin_config.default_scope(self)
        end
      end

      def apply_pagination(chain)
        page_method_name = Kaminari.config.page_method_name
        page = params[Kaminari.config.param_name]

        chain.send(page_method_name, page).per(per_page)
      end

      def per_page
        return max_csv_records if request.format == 'text/csv'
        return max_per_page if active_admin_config.paginate == false

        @per_page || active_admin_config.per_page
      end

      def max_csv_records
        10_000
      end

      def max_per_page
        10_000
      end

      def apply_decorator(chain)
        if decorator?
          decorator_class.decorate_collection(chain)
        else
          chain
        end
      end

    end
  end
end
