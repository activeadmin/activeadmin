# frozen_string_literal: true

# Changes an ActiveAdmin.application or namespace setting for the current
# example only.
#
#   set_application_setting(:site_title, "My Great Site")
#   set_namespace_setting(:admin, :authorization_adapter, MyAdapter)
#
# Restore the stored definition and its inheritance, not an evaluated value.
# This keeps Proc settings dynamic and inherited namespace settings connected
# to the application after the example finishes.
module ApplicationSettingsHelper
  def set_application_setting(name, value)
    application = ActiveAdmin.application
    settings = application.settings.respond_to?(name) ? application.settings : application.namespace_settings
    change_setting(settings, name, value)
  end

  def set_namespace_setting(namespace_name, name, value)
    change_setting(ActiveAdmin.application.namespace(namespace_name).settings, name, value)
  end

  private

  def change_setting(settings, name, value)
    # Dynamic settings store their definition in a separate class attribute.
    attribute = settings.respond_to?(:"#{name}_setting") ? :"#{name}_setting" : name
    @original_settings ||= {}
    snapshot = @original_settings[[settings, attribute]] ||= { value: settings.public_send(attribute), added_methods: [] }
    methods_before = local_setting_methods(settings)

    settings.public_send(:"#{name}=", value)
  ensure
    snapshot[:added_methods] |= local_setting_methods(settings) - methods_before if snapshot
  end

  def local_setting_methods(settings)
    settings.singleton_class.instance_methods(false) + settings.singleton_class.private_instance_methods(false)
  end

  def restore_application_settings
    snapshots = @original_settings
    @original_settings = nil
    snapshots&.reverse_each do |(settings, attribute), snapshot|
      settings.public_send(:"#{attribute}=", snapshot[:value])
      # A class-attribute write can create local accessors. Remove those to
      # restore inheritance, without depending on Rails' accessor names.
      snapshot[:added_methods].each { |method| settings.singleton_class.remove_method(method) }
    end
  end
end

RSpec.configure do |config|
  config.include ApplicationSettingsHelper

  config.after { restore_application_settings }
end
