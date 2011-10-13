module ActiveAdmin
  class AuthorizationAdapter

    # default AuthorizationAdapter:  all authorization requests return true
    #
    # to define your own, you simply need to include these three methods,
    # and handle your authorization process in authorized?
    #
    # if you need to make a before_filter call, there's a method provided
    #
    # it receives the following:
    #   :current_user => the result of the current_user_method call
    #   :resource => the resource we're attempting to access
    #   :action => the action we're attempting on that resource
    #   :controller => the controller we're trying to access
    #
    # why :resource and :controller? when we're rendering menus, or looking
    # at an index page, we don't have a specific instance to check against.
    # in that case, we're trying to determine if we have access to view all
    # of them.
    #
    # from a menu item, we have a route, which belongs to a controller.
    # so boom.

    def initialize
    end

    def authorized?(*args)
      true
    end

    def controller_before_filter
    end

  end
end
