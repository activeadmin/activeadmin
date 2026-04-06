module ActionPolicy::ActiveAdmin
  class CommentPolicy < ActionPolicy::ApplicationPolicy
    scope_for(:active_admin) do |relation|
      relation.where(author: user)
    end

    def destroy? = author? || administrator?
  end
end
