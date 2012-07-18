module ActiveAdmin

  module Authorization
    READ    = :read
    CREATE  = :create
    UPDATE  = :edit
    DESTROY = :destroy
  end

  Auth = Authorization

  class AuthorizationAdapter
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def authorized?(user, action, subject = nil)
      return true
    end

  end

end
