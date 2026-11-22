# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::DatabaseHitDuringLoad do
  it "reports the first application frame and the original database error" do
    exception = ActiveRecord::StatementInvalid.new("no such table: posts")
    exception.set_backtrace(
      [
        "/gems/active_record/connection.rb:10:in 'execute'",
        "/project/app/admin/posts.rb:12:in '<main>'",
        "/project/app/admin/categories.rb:30:in '<main>'"
      ]
    )

    expect do
      described_class.capture { raise exception }
    end.to raise_error(described_class) { |error|
      expect(error.message).to include("app/admin/posts.rb (line 12)", "no such table: posts")
      expect(error.message).not_to include("app/admin/categories.rb")
      expect(error.cause).to equal(exception)
    }
  end

  it "returns the result when no database error occurs" do
    expect(described_class.capture { :loaded }).to eq(:loaded)
  end

  it "lets unrelated errors pass through" do
    expect do
      described_class.capture { raise ArgumentError, "invalid configuration" }
    end.to raise_error(ArgumentError, "invalid configuration")
  end
end
