# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Application do
  let(:application) { ActiveAdmin::Application.new }
  let(:controllers) { application.controllers_for_filters }

  it "controllers_for_filters" do
    expect(application.controllers_for_filters).to eq [
      ActiveAdmin::BaseController, ActiveAdmin::Devise::SessionsController,
      ActiveAdmin::Devise::PasswordsController, ActiveAdmin::Devise::UnlocksController,
      ActiveAdmin::Devise::RegistrationsController, ActiveAdmin::Devise::ConfirmationsController
    ]
  end

  %w[
    skip_before_action skip_around_action skip_after_action
    append_before_action append_around_action append_after_action
    prepend_before_action prepend_around_action prepend_after_action
    before_action around_action after_action
  ].each do |filter|
    it filter do
      args = [:my_filter, { only: :show }]
      controllers.each { |c| expect(c).to receive(filter).with(args) }
      application.public_send filter, args
    end
  end
end
