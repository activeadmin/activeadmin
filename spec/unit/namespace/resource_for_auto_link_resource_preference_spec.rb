# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Namespace, "#resource_for" do
  let(:application) { ActiveAdmin::Application.new }
  let(:namespace) { ActiveAdmin::Namespace.new(application, :super_admin) }

  after { namespace.unload! }

  it "prefers the canonical resource when multiple map to the same table" do
    stub_const("ActiveUser", Class.new(User) do
      def self.model_name
        User.model_name
      end
    end)

    active_user = namespace.register ActiveUser
    user = namespace.register User

    expect(namespace.resource_for(ActiveUser)).to eq user
    expect(namespace.resource_for(ActiveUser)).to_not eq active_user
  end
end

