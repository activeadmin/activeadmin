module ActiveAdmin
  class CommentPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end
  end
end
