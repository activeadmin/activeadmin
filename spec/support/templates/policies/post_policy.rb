class PostPolicy < ApplicationPolicy
  def update?
    record.author == user
  end

  def destroy?
    update?
  end
end
