# frozen_string_literal: true
class Profile < ActiveRecord::Base
  belongs_to :user
end
