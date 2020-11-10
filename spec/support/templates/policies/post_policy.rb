# frozen_string_literal: true
class PostPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    record.category.name != "Announcements" || user.admin
  end

  def update?
    record.author == user
  end
end
