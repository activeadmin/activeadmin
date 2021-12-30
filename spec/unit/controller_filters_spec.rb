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

  expected_actions = (
    prefixes = %w(skip append prepend) << nil
    positions = %w(before around after)
    suffixes = %w(action)
    base = %w()

    prefixes.each_with_object(base) do |prefix, stack|
      positions.each do |position|
        suffixes.each do |suffix|
          stack << [prefix, position, suffix].compact.join("_").to_sym
        end
      end
    end
  )

  expected_actions.each do |action|
    it action do
      args = [:my_filter, { only: :show }]
      controllers.each { |c| expect(c).to receive(action).with(args) }
      application.public_send action, args
    end
  end
end
