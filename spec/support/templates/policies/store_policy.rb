class StorePolicy < ApplicationPolicy
  def destroy?
    false
  end
end
