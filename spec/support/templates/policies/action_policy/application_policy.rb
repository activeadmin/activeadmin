class ActionPolicy::ApplicationPolicy < ActionPolicy::Base
  def initialize(record = nil, user:)
    super
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    create?
  end

  def create?
    false
  end

  def edit?
    update?
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def destroy_all?
    false
  end

  private

  def authenticated?
    return false if user.blank?

    true
  end

  def not_authenticated?
    !authenticated?
  end

  def author?
    authenticated? && record.try(:author) == user
  end

  def owner?
    authenticated? && record.try(:owner) == user
  end

  def user_record?
    authenticated? && record == user
  end

  def administrator?
    authenticated? && user.try(:administrator?)
  end
end
