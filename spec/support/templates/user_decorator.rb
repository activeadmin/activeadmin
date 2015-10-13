require "draper"

class UserDecorator < Draper::Decorator
  delegate_all

  def profile_id
    return unless profile

    profile.id
  end

  def profile_id=(value)
    model.profile = Profile.find(value)
    value
  end
end
