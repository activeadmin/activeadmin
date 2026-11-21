# frozen_string_literal: true

# Changes an ActiveAdmin.application setting for the current example only.
#
#   set_application_setting(:site_title, "My Great Site")
#
# The original value is restored after the example, even if it fails, so
# the change doesn't carry into later specs in the same worker. This
# replaces Cucumber's tag hooks such as @site_title and @breadcrumb.
module ApplicationSettingsHelper
  def set_application_setting(name, value)
    @original_application_settings ||= {}
    unless @original_application_settings.key?(name)
      @original_application_settings[name] = ActiveAdmin.application.public_send(name)
    end

    ActiveAdmin.application.public_send(:"#{name}=", value)
  end

  private

  def restore_application_settings
    @original_application_settings.each do |name, value|
      ActiveAdmin.application.public_send(:"#{name}=", value)
    end
  end
end

RSpec.configure do |config|
  config.include ApplicationSettingsHelper

  config.after do
    restore_application_settings if @original_application_settings
  end
end
