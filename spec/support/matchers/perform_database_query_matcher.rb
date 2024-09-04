# frozen_string_literal: true

RSpec::Matchers.define :perform_database_query do |query|
  match do |block|
    query_regexp = query.is_a?(Regexp) ? query : Regexp.new(Regexp.escape(query))

    @match = nil

    callback = lambda do |_name, _started, _finished, _unique_id, payload|
      @match ||= query_regexp.match?(payload[:sql])
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
