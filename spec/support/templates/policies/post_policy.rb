class PostPolicy < ApplicationPolicy
  def update?
    record.author == user
  end
end
