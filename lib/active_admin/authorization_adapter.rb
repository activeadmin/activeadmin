module ActiveAdmin

  # Default Authorization permissions for Active Admin
  module Authorization
    READ    = :read
    CREATE  = :create
    UPDATE  = :update
    DESTROY = :destroy
  end

  Auth = Authorization


  # Active Admin's default authorization adapter. This adapter returns true
  # for all requests to `#authorized?`. It should be the starting point for
  # implementing your own authorization adapter.
  #
  # To view an example subclass, check out `ActiveAdmin::CanCanAdapter`
  class AuthorizationAdapter
    attr_reader :resource, :user


    # Initialize a new authorization adapter. This happens on each and
    # every request to a controller.
    #
    # @param [ActiveAdmin::Resource, ActiveAdmin::Page] resource The resource
    #        that the user is currently on. Note, we may be authorizing access
    #        to a different subject, so don't rely on this other than to
    #        pull configuration information from.
    #
    # @param [any] user The current user. The user is set to whatever is returned
    #        from `#current_active_admin_user` in the controller.
    #
    def initialize(resource, user)
      @resource = resource
      @user = user
    end

    # Returns true of false depending on if the user is authorized to perform
    # the action on the subject.
    #
    # @param [Symbol] action The name of the action to perform. Usually this will be
    #        one of the `ActiveAdmin::Auth::*` symbols.
    #
    # @param [any] subject The subject the action is being performed on Usually this
    #        is a model object.
    #
    # @returns [Boolean]
    def authorized?(action, subject = nil)
      true
    end


    # A hook method for authorization libraries to scope the collection. By
    # default, we just return the same collection. The returned scope is used
    # as the starting point for all queries to the db in the controller.
    #
    # @param [ActiveRecord::Relation] collection The collection the user is
    #        attempting to view.
    #
    # @returns [ActiveRecord::Relation] A new collection, scoped to the 
    #          objects that the current user has access to.
    def scope_collection(collection)
      collection
    end

  end

end
