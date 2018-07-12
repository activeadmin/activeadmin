class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    record.author == user
  end

  def destroy?
    update?
  end
end
