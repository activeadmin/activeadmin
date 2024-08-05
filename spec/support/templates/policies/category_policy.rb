# frozen_string_literal: true
class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(hidden: false)
    end
  end
end
