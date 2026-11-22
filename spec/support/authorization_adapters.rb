# frozen_string_literal: true

# Sets up the admin namespace with one of the authorization adapters the
# authorization specs run against, and registers Post and a "No Access"
# page. Each adapter allows reading posts and the Dashboard, and denies
# editing a post without an author and the "No Access" page.
#
#   use_authorization_adapter(:cancan)
#   use_authorization_adapter(:cancan) { action_item(:x) { ... } }
#
# A block is used as Post's registration block.
#
# :custom is a hand-written ActiveAdmin::AuthorizationAdapter, :cancan uses
# a stubbed Ability class, and :pundit uses the test app's policies
# (spec/support/templates/policies). The adapter setting and the Ability
# constant are restored after the example.
module AuthorizationAdapterHelpers
  ADAPTERS = [:custom, :cancan, :pundit].freeze

  def use_authorization_adapter(name, &post_config)
    adapter =
      case name
      when :custom then custom_authorization_adapter
      when :cancan then stub_cancan_ability && ActiveAdmin::CanCanAdapter
      when :pundit then ActiveAdmin::PunditAdapter
      else raise ArgumentError, "unknown adapter #{name.inspect}"
      end

    set_namespace_setting(:admin, :authorization_adapter, adapter)
    register_resources do
      ActiveAdmin.register(Post, &post_config)
      ActiveAdmin.register_page "No Access"
    end
  end

  private

  def custom_authorization_adapter
    Class.new(ActiveAdmin::AuthorizationAdapter) do
      def authorized?(action, subject = nil)
        case subject
        when normalized(Post)
          ![:edit, :update, :destroy].include?(action)
        when ActiveAdmin::Page
          subject.name != "No Access"
        else
          false
        end
      end
    end
  end

  def stub_cancan_ability
    ability = Class.new do
      include CanCan::Ability

      def initialize(user)
        can [:edit, :destroy], Post, author_id: user.id
        can :read, Post

        can :read, ActiveAdmin::Page, name: "Dashboard"
        cannot :read, ActiveAdmin::Page, name: "No Access"
      end
    end

    # The CanCan adapter looks up the ability class by name.
    stub_const("Ability", ability)
  end
end

RSpec.configure do |config|
  config.include AuthorizationAdapterHelpers, type: :request
  config.include AuthorizationAdapterHelpers, type: :system
end
