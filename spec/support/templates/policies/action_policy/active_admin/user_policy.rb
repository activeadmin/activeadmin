module ActionPolicy::ActiveAdmin
  class UserPolicy < ActionPolicy::ApplicationPolicy
    scope_for(:active_admin) do |relation|
      administrator? ? relation : relation.none
    end

    def index? = administrator?

    def show? = administrator?

    def create? = administrator?

    def update? = administrator?

    def destroy? = administrator?

    def destroy_all? = administrator?
  end
end
