module ActiveAdmin
  class CommentPolicy < ApplicationPolicy
    def destroy?
      record.author == user
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(author: user)
      end
    end
  end
end
