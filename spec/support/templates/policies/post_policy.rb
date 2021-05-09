# frozen_string_literal: true
class PostPolicy < ApplicationPolicy
  def update?
    record.author == user
  end
end
