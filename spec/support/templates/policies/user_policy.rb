class UserPolicy < ApplicationPolicy
  def destroy_all?
    true
  end
end
