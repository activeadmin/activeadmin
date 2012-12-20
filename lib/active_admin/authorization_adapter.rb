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
    # @param [any] subject The subject the action is being performed on usually this
    #        is a model object. Note, that this is NOT always in instance, it can be 
    #        the class of the subject also. For example, Active Admin uses the class
    #        of the resource to decide if the resource should be displayed in the 
    #        global navigation. To deal with this nicely in a case statement, take
    #        a look at `#normalized(klasss)`
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

    private

    # The `#authorized?` method's subject can be set to both instances as well
    # as classes of objects. This can make it much difficult to create simple
    # case statements for authorization since you have to handle both the 
    # class level match and the instance level match.
    #
    # For example:
    #
    #     class MyAuthAdapter < ActiveAdmin::AuthorizationAdapter
    #
    #       def authorized?(action, subject = nil)
    #         case subject
    #         when Post
    #           true
    #         when Class
    #           if subject == Post
    #             true
    #           end
    #         end
    #       end
    #
    #     end
    #
    # To handle this, the normalized method takes care of returning a object
    # which implements `===` to be matched in a case statement.
    #
    # The above now becomes:
    #
    #     class MyAuthAdapter < ActiveAdmin::AuthorizationAdapter
    #
    #       def authorized?(action, subject = nil)
    #         case subject
    #         when normalized(Post)
    #           true
    #         end
    #       end
    #
    #     end
    def normalized(klass)
      NormalizedMatcher.new(klass)
    end

    class NormalizedMatcher

      def initialize(klass)
        @klass = klass
      end

      def ===(other)
        @klass == other || other.is_a?(@klass)
      end

    end

  end

end
