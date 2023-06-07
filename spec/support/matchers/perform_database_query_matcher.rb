# frozen_string_literal: true

RSpec::Matchers.define :perform_database_query do |query|
  match do |block|
    @match = nil

    callback = lambda do |_name, _started, _finished, _unique_id, payload|
      @match = Regexp.new(Regexp.escape(query)).match?(payload[:sql])
    end

    ActiveSupport::Notifications.subscribed(callback, "sql.active_record", &block)

    @match
  end

  failure_message do |_|
    "Expected queries like \"#{query}\" but none were made"
  end

  failure_message_when_negated do |_|
    "Expected no queries like \"#{query}\" but at least one were made"
  end

  supports_block_expectations
end
