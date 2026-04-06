module ActionPolicy::ActiveAdmin
  class PagePolicy < ActionPolicy::ApplicationPolicy
    def show?
      case record.name
      when "Dashboard"
        true
      else
        false
      end
    end
  end
end
