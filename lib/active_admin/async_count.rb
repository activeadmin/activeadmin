# frozen_string_literal: true
module ActiveAdmin
  class AsyncCount
    class NotSupportedError < RuntimeError; end

    def initialize(collection)
      raise NotSupportedError, "#{collection.inspect} does not support :async_count" unless collection.respond_to?(:async_count)

      @collection = collection.except(:select, :order)
      @promise = @collection.async_count
    end

    def count
      value = @promise.value
      # value.value due to Rails bug https://github.com/rails/rails/issues/50776
      value.respond_to?(:value) ? value.value : value
    end

    alias size count

    delegate :except, :group_values, :length, :limit_value, to: :@collection
  end
end
