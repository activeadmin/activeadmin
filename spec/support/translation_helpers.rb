# frozen_string_literal: true

module TranslationHelpers
  def with_translation(scope, value)
    locale = I18n.locale
    previous_value = nil

    previous_scope = scope.each_with_object([]) do |part, subscope|
      subscope << part
      previous_value = I18n.t(subscope.join("."), locale: locale, default: nil)
      break subscope if previous_value.nil?
    end

    I18n.backend.store_translations locale, to_translation_hash(scope, value)
    yield
  ensure
    I18n.backend.store_translations locale, to_translation_hash(previous_scope, previous_value)
  end

  private

  def to_translation_hash(scope, value)
    scope.reverse.inject(value) { |assigned_value, key| { key => assigned_value } }
  end
end
