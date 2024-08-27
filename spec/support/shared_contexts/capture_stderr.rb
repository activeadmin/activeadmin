# frozen_string_literal: true

RSpec.shared_context "capture stderr" do
  around do |example|
    original_stderr = $stderr
    $stderr = StringIO.new
    example.run
    $stderr = original_stderr
  end
end
