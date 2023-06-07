# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin do
  %w(register register_page unload! load! routes).each do |method|
    it "delegates ##{method} to application" do
      expect(ActiveAdmin.application).to receive(method)

      ActiveAdmin.send(method)
    end
  end
end
