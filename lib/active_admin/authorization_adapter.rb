module ActiveAdmin

  module Authorization
    READ    = :read
    CREATE  = :create
    UPDATE  = :edit
    DESTROY = :destroy
  end

  Auth = Authorization

  class AuthorizationAdapter
    attr_reader :resource, :user

    def initialize(resource, user)
      @resource = resource
      @user = user
    end

    def authorized?(action, subject = nil)
      return true
    end

    def scope_collection(collection)
      collection
    end

  end

end
