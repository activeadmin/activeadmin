class AdminUserPolicy < ApplicationPolicy
  def destroy?
    record != user
  end
end
